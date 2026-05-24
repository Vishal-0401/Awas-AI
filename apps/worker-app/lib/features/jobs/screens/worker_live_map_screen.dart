import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/services/socket_service.dart';
import '../../../core/services/telemetry_service.dart';
import '../../../core/widgets/premium_dashboard_widgets.dart';

class WorkerLiveMapScreen extends ConsumerStatefulWidget {
  const WorkerLiveMapScreen({super.key});

  @override
  ConsumerState<WorkerLiveMapScreen> createState() => _WorkerLiveMapScreenState();
}

class _WorkerLiveMapScreenState extends ConsumerState<WorkerLiveMapScreen>
    with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.4595, 77.0266),
    zoom: 14.0,
  );

  // --- socket / simulation ---
  final SocketService _socket = SocketService();
  StreamSubscription<Map<String, dynamic>>? _dispatchSub;
  Timer? _retryTimer;

  // --- UI state ---
  bool _isOnline = false;
  bool _isSocketConnecting = false;
  bool _didInitialLoad = false;
  String? _errorMessage;

  // Keep map markers in a rebuild-friendly mutable set.
  final Set<Marker> _markers = {};

  // --- job state ---
  final List<DispatchJob> _queue = [];
  DispatchJob? _recommended;
  DispatchJob? _activeDispatch;

  // --- heatmap overlay ---
  final List<HeatZone> _heatZones = [

    HeatZone(center: LatLng(28.4658, 77.0318), intensity: 0.9),
    HeatZone(center: LatLng(28.4512, 77.0185), intensity: 0.75),
    HeatZone(center: LatLng(28.4588, 77.0212), intensity: 0.55),
  ];
  bool _showHeatmap = true;

  // --- recompute animation ---
  late final AnimationController _cardPulse;

  @override
  void initState() {
    super.initState();
    _cardPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _initMarkers();
    _tryConnectSocket();
  }

  @override
  void dispose() {
    _dispatchSub?.cancel();
    _retryTimer?.cancel();
    try {
      _socket.disconnect();
    } catch (_) {}
    _cardPulse.dispose();
    super.dispose();
  }

  // Riverpod telemetry
  @override
  Widget build(BuildContext context) {
    final telemetry = ref.watch(telemetryProvider);
    final workerLocation = telemetry.currentLocation;

    // Update marker positions + recommendation when telemetry changes.
    if (workerLocation != null) {
      _updateWorkerMarker(workerLocation.lat, workerLocation.lng);
    }

    if (!_didInitialLoad && workerLocation != null) {
      _didInitialLoad = true;
      // Seed with some initial queue jobs near the worker.
      if (_queue.isEmpty) _seedInitialQueue(workerLocation);
      _recomputeRecommendation();
    }

    // marker set update triggers google maps repaint.
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, telemetry),
      body: Stack(
        children: [
          _buildMap(),
          _buildHeatmapOverlay(),
          _buildTopTelemetryOverlay(telemetry),
          _buildAIRecommendationBanner(),
          _buildBottomSheet(),
          _buildLoadingRetryOverlay(),
        ],
      ),
      floatingActionButton: _buildFloatingControls(),
    );
  }

  // --------------------------- init / markers ---------------------------

  void _initMarkers() {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId('worker'),
        position: const LatLng(28.4595, 77.0266),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: const InfoWindow(title: 'Worker'),
      ),
    );

    // Job markers will be added from _queue.
    for (final job in _queue) {
      _markers.add(_jobMarker(job));
    }
  }

  void _updateWorkerMarker(double lat, double lng) {
    // Update worker marker.
    final id = const MarkerId('worker');
    _markers.removeWhere((m) => m.markerId == id);

    _markers.add(
      Marker(
        markerId: id,
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: const InfoWindow(title: 'Worker (live)'),
      ),
    );

    // Keep map centered loosely for ops feel.
    // Avoid excessive animate calls: only do it when no active job.
    if (_activeDispatch == null && mounted) {
      _mapController
          .animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    }
  }

  Marker _jobMarker(DispatchJob job) {
    final isRecommended = job.id == _recommended?.id;
    final hue = isRecommended
        ? BitmapDescriptor.hueOrange
        : (job.premium ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange);

    return Marker(
      markerId: MarkerId('job_${job.id}'),
      position: job.location,
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: job.serviceName,
        snippet: '${job.distanceKm.toStringAsFixed(1)} km • ETA ${job.etaMin} min',
      ),
    );
  }

  void _refreshJobMarkers() {
    // Remove existing job markers.
    _markers.removeWhere((m) => m.markerId.value.startsWith('job_'));
    for (final job in _queue) {
      _markers.add(_jobMarker(job));
    }
  }

  // --------------------------- socket handling ---------------------------

  Future<void> _tryConnectSocket() async {
    setState(() {
      _isSocketConnecting = true;
      _errorMessage = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 450));

    try {
      _socket.connect();
      _socket.emitWorkerOnline();

      _dispatchSub?.cancel();
      _dispatchSub = _socket.onNewDispatch.listen((payload) {
        final job = DispatchJob.fromSocketPayload(payload);
        _onNewDispatch(job);
      });

      setState(() {
        _isSocketConnecting = false;
        _isOnline = true;
        _errorMessage = null;
      });

      // Simulate some incoming events.
      _socket.simulateNewJob();
      _scheduleMoreSimulations();
    } catch (e) {
      _scheduleRetry(e.toString());
    }
  }

  void _scheduleMoreSimulations() {
    _retryTimer?.cancel();

    // Simulate new dispatches periodically.
    _retryTimer = Timer.periodic(const Duration(seconds: 18), (t) {
      if (!_isOnline) return;
      _socket.simulateNewJob();
    });
  }

  void _scheduleRetry(String reason) {
    setState(() {
      _isSocketConnecting = false;
      _isOnline = false;
      _errorMessage = reason;
    });

    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 8), () {
      _tryConnectSocket();
    });
  }

  void _onNewDispatch(DispatchJob job) {
    // Merge job into queue.
    final existingIndex = _queue.indexWhere((j) => j.id == job.id);

    if (existingIndex >= 0) {
      _queue[existingIndex] = job;
    } else {
      _queue.insert(0, job);
    }

    // Trim queue.
    if (_queue.length > 8) _queue.removeRange(8, _queue.length);

    // Compute ETA/distance/earnings using current worker location.
    final worker = ref.read(telemetryProvider).currentLocation;
    if (worker != null) {
      for (final j in _queue) {
        j.updateComputedMetricsFromWorker(workerLatLng: worker);
      }
    }

    _recomputeRecommendation();

    setState(() {
      // Keep bottom card aligned to the highest scoring job.
      // Only set active dispatch if no active dispatch.
      if (_activeDispatch == null) {
        _activeDispatch = _recommended;
      }
      _refreshJobMarkers();
    });

    // Animate card pulse on new job.
    _cardPulse
      ..reset()
      ..forward();
  }

  // --------------------------- recommendation ---------------------------

  void _seedInitialQueue(Location workerLocation) {
    // Create job candidates around worker for initial premium ops UI.
    final base = LatLng(workerLocation.lat, workerLocation.lng);

    final candidates = [
      DispatchJob(
        id: 'seed_1',
        serviceName: 'Electrical Repair',
        customerName: 'Priority Customer',
        premium: true,
        payout: 450,
        location: _offsetLatLng(base, 0.0048, 0.0032),
      ),
      DispatchJob(
        id: 'seed_2',
        serviceName: 'Plumbing Repair',
        customerName: 'Sector 42 Home',
        premium: false,
        payout: 320,
        location: _offsetLatLng(base, -0.0032, -0.0022),
      ),
      DispatchJob(
        id: 'seed_3',
        serviceName: 'AC Service',
        customerName: 'Tech Park Office',
        premium: true,
        payout: 520,
        location: _offsetLatLng(base, 0.0016, -0.0042),
      ),
    ];

    for (final c in candidates) {
      c.updateComputedMetricsFromWorker(workerLatLng: workerLocation);
      _queue.add(c);
    }

    _refreshJobMarkers();
  }

  LatLng _offsetLatLng(LatLng base, double dLat, double dLng) {
    return LatLng(base.latitude + dLat, base.longitude + dLng);
  }

  void _recomputeRecommendation() {
    final worker = ref.read(telemetryProvider).currentLocation;
    if (worker == null) return;

    for (final j in _queue) {
      j.updateComputedMetricsFromWorker(workerLatLng: worker);
      j.earningsEstimate = _estimateEarnings(j, worker);
      j.demandIntensity = _computeDemandIntensity(j.location);
    }

    if (_queue.isEmpty) {
      _recommended = null;
      _activeDispatch = null;
      return;
    }

    final sorted = [..._queue]
      ..sort((a, b) => b.score(worker).compareTo(a.score(worker)));

    _recommended = sorted.first;

    // If active dispatch exists, keep it unless it is rejected.
    if (_activeDispatch == null || !_queue.any((j) => j.id == _activeDispatch!.id)) {
      _activeDispatch = _recommended;
    }

    _refreshJobMarkers();
  }

  double _estimateEarnings(DispatchJob job, Location worker) {
    final demand = _computeDemandIntensity(job.location);
    final premiumBoost = job.premium ? 0.18 : 0.08;

    // Ops-inspired: higher demand + closer distance => better effective earnings.
    final distanceFactor = max(0.6, 1.0 - job.distanceKm / 18.0);
    final surge = 1.0 + (demand * 0.45) + premiumBoost;

    final est = job.payout * surge * distanceFactor;
    return max(60, est);
  }

  double _computeDemandIntensity(LatLng loc) {
    double best = 0;
    for (final z in _heatZones) {
      final dKm = _haversineKm(loc, z.center);
      final radiusKm = 2.8 + (z.intensity * 1.3);
      final t = (1.0 - (dKm / radiusKm)).clamp(0.0, 1.0);
      best = max(best, t * z.intensity);
    }
    return best;
  }

  double _haversineKm(LatLng a, LatLng b) {
    const R = 6371.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLng = _deg2rad(b.longitude - a.longitude);
    final la1 = _deg2rad(a.latitude);
    final la2 = _deg2rad(b.latitude);
    final h =
        sin(dLat / 2) * sin(dLat / 2) + cos(la1) * cos(la2) * sin(dLng / 2) * sin(dLng / 2);
    return 2 * R * asin(sqrt(h));
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);

  // --------------------------- UI pieces ---------------------------

  PreferredSizeWidget _buildAppBar(BuildContext context, TelemetryState telemetry) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20.r),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'DISPATCH CONSOLE',
        style: AppTypography.h3.copyWith(
          color: AppColors.accentCyan,
          letterSpacing: 2,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: AppSpacing.sm.w),
          child: GlassCard(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            color: _isOnline
                ? AppColors.accentCyan.withOpacity(0.18)
                : AppColors.surfaceHighlight,
            borderRadius: BorderRadius.circular(20.r),
            child: Row(
              children: [
                NeonStatusIndicator(
                  isActive: _isOnline && !_isSocketConnecting,
                  size: 8,
                ),
                SizedBox(width: AppSpacing.xs.w),
                Text(
                  _isSocketConnecting
                      ? 'CONNECTING'
                      : _isOnline
                          ? 'ONLINE'
                          : 'OFFLINE',
                  style: AppTypography.caption.copyWith(
                    color: _isOnline ? AppColors.accentCyan : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      onMapCreated: (c) => _mapController = c,
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      style: _mapStyle,
      // Heatmap demand via tile overlay isn't supported with core plugin here.
      // We'll render a custom overlay using Stack.
    );
  }

  Widget _buildHeatmapOverlay() {
    if (!_showHeatmap) return const SizedBox.shrink();

    // Glass radial zones as premium "heat" feel.
    // These are visual placeholders; in production you'd align with map projection.
    return IgnorePointer(
      child: Stack(
        children: _heatZones.map((z) {
          final size = (140 + z.intensity * 190).w;
          // Place zones relative to screen; placeholder positioning.
          // Using deterministic offsets so it looks stable.
          final dx = (z.center.longitude % 1) * 220;
          final dy = (z.center.latitude % 1) * 240;
          return Positioned(
            left: 40.w + dx,
            top: 120.h + dy,
            child: _HeatCircle(
              size: size,
              intensity: z.intensity,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopTelemetryOverlay(TelemetryState telemetry) {
    final loc = telemetry.currentLocation;

    final lastLat = loc?.lat ?? 0;
    final lastLng = loc?.lng ?? 0;

    final updatedAgo = _isOnline
        ? 'Live GPS • ${(DateTime.now().second % 60).toString().padLeft(2, '0')}s'
        : 'GPS paused';

    return Positioned(
      top: MediaQuery.of(context).padding.top + kToolbarHeight + 12.h,
      left: AppSpacing.md.w,
      right: AppSpacing.md.w,
      child: GlassCard(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.surface.withOpacity(0.55),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.gps_fixed, color: AppColors.accentCyan, size: 18.r),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WORKER TELEMETRY',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${lastLat.toStringAsFixed(5)}, ${lastLng.toStringAsFixed(5)}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  updatedAgo,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accentCyan,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _activeDispatch == null ? 'Idle' : 'Routing',
                  style: AppTypography.caption.copyWith(
                    color: _activeDispatch == null ? AppColors.textSecondary : AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ).animate().fadeIn(duration: 250.ms),
    );
  }

  Widget _buildAIRecommendationBanner() {
    final job = _recommended;
    final demand = job?.demandIntensity ?? 0;

    return Positioned(
      left: AppSpacing.md.w,
      right: AppSpacing.md.w,
      top: MediaQuery.of(context).padding.top + 12.h,
      child: Padding(
        padding: EdgeInsets.only(top: 56.h),
        child: GlassCard(
          color: AppColors.accentCyan.withOpacity(0.06),
          borderRadius: BorderRadius.circular(22.r),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.md.h),
          hasBorder: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.cyanGradient,
                      borderRadius: BorderRadius.circular(999.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentCyan.withOpacity(0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      'AI NEXT',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 20.r),
                ],
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                job == null
                    ? 'Waiting for dispatch candidates'
                    : 'Recommended: ${job.serviceName}',
                style: AppTypography.h3.copyWith(
                  fontSize: 14.sp,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _Badge(icon: Icons.timer, text: job == null ? '--' : '${job.etaMin} min ETA'),
                  SizedBox(width: 8.w),
                  _Badge(icon: Icons.map, text: job == null ? '--' : '${job.distanceKm.toStringAsFixed(1)} km away'),
                  SizedBox(width: 8.w),
                  _Badge(
                    icon: Icons.bolt,
                    text: job == null ? '--' : 'Demand ${(demand * 100).toStringAsFixed(0)}%',
                    accent: true,
                  ),
                  const Spacer(),
                  if (job != null)
                    _Badge(
                      icon: Icons.currency_rupee,
                      text: 'Est ₹${job.earningsEstimate.round()}',
                      accent: true,
                      dark: false,
                    ),
                ],
              ),
            ],
          ),
        ).animate().slideY(begin: -0.25, end: 0).fadeIn(),
      ),
    );
  }

  Widget _buildBottomSheet() {
    final job = _activeDispatch ?? _recommended;

    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.36,
        minChildSize: 0.14,
        maxChildSize: 0.72,
        snap: true,
        snapSizes: const [0.36, 0.72],
        builder: (context, scrollController) {
          return GlassCard(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg.r)),
            padding: EdgeInsets.zero,
            color: AppColors.surface.withOpacity(0.78),
            child: RefreshIndicator(
              onRefresh: () async {
                // Pull-to-refresh simulation.
                _socket.simulateNewJob();
                await Future<void>.delayed(const Duration(milliseconds: 600));
              },
              color: AppColors.accentCyan,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHandle(),
                    if (_isSocketConnecting && _queue.isEmpty)
                      _buildSkeletonDispatchList()
                    else
                      Column(
                        children: [
                          _buildDispatchCard(job),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                            child: SizedBox(
                              height: 1.h,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: AppColors.glassBorder.withOpacity(0.5)),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          _buildJobQueueList(scrollController),
                          SizedBox(height: 12.h),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 44.w,
        height: 4.h,
        margin: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.45),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildDispatchCard(DispatchJob? job) {
    if (job == null) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.md.r),
        child: GlassCard(
          hasBorder: false,
          padding: EdgeInsets.all(AppSpacing.md.r),
          color: AppColors.surfaceHighlight.withOpacity(0.55),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WAITING FOR JOB OFFERS',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Pull down to refresh dispatch candidates.',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final isPremium = job.premium;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: GlassCard(
        hasBorder: false,
        padding: EdgeInsets.all(AppSpacing.md.r),
        color: AppColors.accentCyan.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        child: AnimatedBuilder(
          animation: _cardPulse,
          builder: (context, child) {
            final scale = 1.0 + (_cardPulse.value * 0.035);
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DISPATCH OFFER',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.accentCyan,
                      letterSpacing: 1.6,
                    ),
                  ),
                  _Pill(
                    text: isPremium ? 'PREMIUM' : 'STANDARD',
                    color: isPremium ? AppColors.success : AppColors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                children: [
                  _WorkerAvatar(),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.customerName, style: AppTypography.h2.copyWith(fontSize: 16.sp)),
                        SizedBox(height: 3.h),
                        Text(job.serviceName, style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _DistanceBadge(value: '${job.distanceKm.toStringAsFixed(1)} km'),
                      SizedBox(height: 6.h),
                      Text(
                        'Est ₹${job.earningsEstimate.round()}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _acceptRejectEnabled(job)
                          ? () => _onReject(job)
                          : null,
                      icon: Icon(Icons.close, size: 18.r),
                      label: Text('Reject', style: TextStyle(fontSize: 12.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceHighlight.withOpacity(0.65),
                        foregroundColor: AppColors.textPrimary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _acceptRejectEnabled(job)
                          ? () => _onAccept(job)
                          : null,
                      icon: Icon(Icons.check, size: 18.r),
                      label: Text('Accept', style: TextStyle(fontSize: 12.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentCyan,
                        foregroundColor: AppColors.background,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _buildRoutePreviewPlaceholder(job),
            ],
          ),
        ),
      ),
    );
  }

  bool _acceptRejectEnabled(DispatchJob job) {
    return _isOnline && !_isSocketConnecting && _activeDispatch?.id == job.id;
  }

  void _onAccept(DispatchJob job) {
    setState(() {
      _activeDispatch = job;
      _queue.removeWhere((j) => j.id == job.id);
      _recommended = null;
    });
    _socket.acceptJob(job.id);

    // Fake routing: clear after a short time & keep premium feel.
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _activeDispatch = null;
      });
      _recomputeRecommendation();
    });
  }

  void _onReject(DispatchJob job) {
    setState(() {
      _queue.removeWhere((j) => j.id == job.id);
      if (_activeDispatch?.id == job.id) _activeDispatch = null;
      _recommended = null;
    });

    _socket.rejectJob(job.id);
    _recomputeRecommendation();
  }

  Widget _buildRoutePreviewPlaceholder(DispatchJob job) {
    final worker = ref.read(telemetryProvider).currentLocation;

    final workerLoc =
        worker == null ? job.location : LatLng(worker.lat, worker.lng);

    return GlassCard(
      hasBorder: true,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      borderRadius: BorderRadius.circular(16.r),
      color: AppColors.surface.withOpacity(0.45),
      boxShadow: [
        BoxShadow(
          color: AppColors.accentCyan.withOpacity(0.12),
          blurRadius: 18,
          offset: const Offset(0, 10),
        )
      ],
      child: Row(
        children: [
          Icon(Icons.alt_route, color: AppColors.accentCyan, size: 18.r),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route preview placeholder',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Straight-line estimate • ETA ${job.etaMin} min',
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          _MiniRouteGlyph(
            from: workerLoc,
            to: job.location,
          )
        ],
      ),
    );
  }

  Widget _buildJobQueueList(ScrollController scrollController) {
    final jobs = _queue;

    if (jobs.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.md.r),
        child: Center(
          child: Text(
            'No nearby jobs yet. Pull to refresh.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'JOB QUEUE', actionText: 'Refresh', onActionTap: () async {
            _socket.simulateNewJob();
          }),
          SizedBox(height: AppSpacing.md.h),
          Column(
            children: jobs
                .map((j) => _JobTile(
                      job: j,
                      isActive: _activeDispatch?.id == j.id,
                      isRecommended: j.id == _recommended?.id,
                      onAccept: () => _onAccept(j),
                      onReject: () => _onReject(j),
                    ))
                .toList(),
          ),
          SizedBox(height: 8.h),
          // Premium footer hint.
          Text(
            'AI re-ranks recommendations as your GPS updates.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonDispatchList() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        children: [
          GlassCard(
            hasBorder: false,
            padding: EdgeInsets.all(AppSpacing.md.r),
            color: AppColors.surfaceHighlight.withOpacity(0.35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 140.w, height: 14.h, color: AppColors.surfaceHighlight, child: const SizedBox()),
                SizedBox(height: 10.h),
                Container(width: 220.w, height: 20.h, color: AppColors.surfaceHighlight, child: const SizedBox()),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(child: Container(height: 44.h, color: AppColors.surfaceHighlight)),
                    SizedBox(width: 10.w),
                    Expanded(child: Container(height: 44.h, color: AppColors.surfaceHighlight)),
                  ],
                )
              ],
            ),
          ).animate().shimmer(duration: 900.ms, color: AppColors.accentCyan.withOpacity(0.15)),
          SizedBox(height: AppSpacing.md.h),
          GlassCard(
            hasBorder: false,
            padding: EdgeInsets.all(AppSpacing.md.r),
            color: AppColors.surfaceHighlight.withOpacity(0.35),
            child: Column(
              children: [
                Container(width: 130.w, height: 16.h, color: AppColors.surfaceHighlight, child: const SizedBox()),
                SizedBox(height: 12.h),
                ...List.generate(3, (i) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(height: 62.h, color: AppColors.surfaceHighlight),
                  );
                }),
              ],
            ),
          ).animate().shimmer(duration: 900.ms, color: AppColors.accentCyan.withOpacity(0.15)),
        ],
      ),
    );
  }

  Widget _buildLoadingRetryOverlay() {
    if (_isSocketConnecting && !_didInitialLoad) {
      return Positioned.fill(
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: GlassCard(
              padding: EdgeInsets.all(AppSpacing.md.r),
              color: AppColors.surface.withOpacity(0.65),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 44.w,
                    height: 44.w,
                    child: const CircularProgressIndicator(strokeWidth: 3, color: AppColors.accentCyan),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Connecting dispatch engine…',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null && !_isSocketConnecting) {
      return Positioned.fill(
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: GlassCard(
              padding: EdgeInsets.all(AppSpacing.md.r),
              color: AppColors.surface.withOpacity(0.75),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 30.r, color: AppColors.warning),
                  SizedBox(height: 10.h),
                  Text(
                    'Socket retry needed',
                    style: AppTypography.h2.copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _errorMessage!,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton.icon(
                    onPressed: _tryConnectSocket,
                    icon: Icon(Icons.refresh, size: 18.r),
                    label: Text('Retry Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: AppColors.background,
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFloatingControls() {
    final telem = ref.read(telemetryProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'fab_center',
          mini: true,
          backgroundColor: AppColors.surface.withOpacity(0.8),
          foregroundColor: AppColors.accentCyan,
          onPressed: () {
            final loc = telem.currentLocation;
            if (loc == null) return;
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(loc.lat, loc.lng), zoom: 15.2),
              ),
            );
          },
          child: Icon(Icons.my_location, size: 20.r),
        ),
        SizedBox(height: AppSpacing.sm.h),
        FloatingActionButton(
          heroTag: 'fab_heatmap',
          mini: true,
          backgroundColor: AppColors.surface.withOpacity(0.8),
          foregroundColor: AppColors.accentCyan,
          onPressed: () {
            setState(() => _showHeatmap = !_showHeatmap);
          },
          child: Icon(Icons.heat_pump_rounded, size: 20.r),
        ),
        SizedBox(height: AppSpacing.sm.h),
        FloatingActionButton(
          heroTag: 'fab_refresh_jobs',
          backgroundColor: AppColors.accentCyan,
          foregroundColor: AppColors.background,
          onPressed: () {
            _socket.simulateNewJob();
          },
          child: Icon(Icons.refresh, size: 24.r),
        ),
      ],
    );
  }

  static const String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#121820"}]
    },
    {
      "featureType": "labels.text.fill",
      "stylers": [{"color": "#8b949e"}]
    },
    {
      "featureType": "labels.text.stroke",
      "stylers": [{"color": "#0a0f14"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#1e293b"}]
    },
    {
      "featureType": "water",
      "stylers": [{"color": "#0a0f14"}]
    }
  ]
  ''';
}

// --------------------------- UI helper widgets ---------------------------

class _HeatCircle extends StatelessWidget {
  final double size;
  final double intensity;
  const _HeatCircle({required this.size, required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.accentCyan.withOpacity(0.20 + intensity * 0.25),
            AppColors.accentCyan.withOpacity(0.06 + intensity * 0.12),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
        border: Border.all(
          color: AppColors.accentCyan.withOpacity(0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withOpacity(0.18),
            blurRadius: 36,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool accent;
  final bool dark;

  const _Badge({
    required this.icon,
    required this.text,
    this.accent = false,
    this.dark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.accentCyan.withOpacity(0.12)
            : AppColors.surfaceHighlight.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: accent
              ? AppColors.accentCyan.withOpacity(0.35)
              : AppColors.glassBorder.withOpacity(0.55),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent ? AppColors.accentCyan : AppColors.textSecondary, size: 14.r),
          SizedBox(width: 6.w),
          Text(
            text,
            style: AppTypography.caption.copyWith(
              color: accent ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _WorkerAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.r,
      height: 52.r,
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight.withOpacity(0.7),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accentCyan.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withOpacity(0.16),
            blurRadius: 18,
          )
        ],
      ),
      child: Icon(Icons.person_rounded, color: AppColors.accentCyan, size: 24.r),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  final String value;
  const _DistanceBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.6)),
      ),
      child: Text(
        value,
        style: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _JobTile extends StatelessWidget {
  final DispatchJob job;
  final bool isActive;
  final bool isRecommended;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _JobTile({
    required this.job,
    required this.isActive,
    required this.isRecommended,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: GlassCard(
        padding: EdgeInsets.all(AppSpacing.sm.r),
        margin: EdgeInsets.zero,
        hasBorder: false,
        color: isRecommended
            ? AppColors.accentCyan.withOpacity(0.07)
            : AppColors.surface.withOpacity(0.35),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        boxShadow: [
          BoxShadow(
            color: isRecommended ? AppColors.accentCyan.withOpacity(0.16) : Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlight.withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isRecommended ? AppColors.accentCyan.withOpacity(0.35) : AppColors.glassBorder.withOpacity(0.55),
                    ),
                  ),
                  child: Icon(
                    Icons.build_outlined,
                    color: isRecommended ? AppColors.accentCyan : AppColors.textSecondary,
                    size: 18.r,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.serviceName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '${job.customerName}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${job.distanceKm.toStringAsFixed(1)} km',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'ETA ${job.etaMin} min',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _Chip(
                    icon: Icons.bolt,
                    text: 'Demand ${(job.demandIntensity * 100).toStringAsFixed(0)}%',
                    accent: isRecommended,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _Chip(
                    icon: Icons.currency_rupee,
                    text: '₹${job.earningsEstimate.round()}',
                    accent: isRecommended,
                  ),
                ),
              ],
            ),
            if (isActive)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReject,
                        icon: Icon(Icons.close, size: 16.r, color: AppColors.textPrimary),
                        label: Text('Reject', style: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.surfaceHighlight.withOpacity(0.45),
                          side: BorderSide(color: AppColors.glassBorder.withOpacity(0.7)),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        icon: Icon(Icons.check, size: 16.r),
                        label: Text('Accept', style: TextStyle(color: AppColors.background, fontSize: 12.sp)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCyan,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  'Offer idle • Tap Accept on recommended card',
                  style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
                ),
              )
          ],
        ),
      ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1)),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool accent;
  const _Chip({required this.icon, required this.text, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: accent ? AppColors.accentCyan.withOpacity(0.10) : AppColors.surfaceHighlight.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: accent ? AppColors.accentCyan.withOpacity(0.32) : AppColors.glassBorder.withOpacity(0.55),
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 16.r,
              color: accent ? AppColors.accentCyan : AppColors.textSecondary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: accent ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniRouteGlyph extends StatelessWidget {
  final LatLng from;
  final LatLng to;

  const _MiniRouteGlyph({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    // Simple direction glyph placeholder.
    final dx = (to.longitude - from.longitude);
    final dy = (to.latitude - from.latitude);
    final angle = atan2(dy, dx);

    return Container(
      width: 44.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.6)),
      ),
      child: Center(
        child: Transform.rotate(
          angle: angle,
          child: Icon(Icons.alt_route, size: 16.r, color: AppColors.accentCyan),
        ),
      ),
    );
  }
}

// --------------------------- domain models ---------------------------

enum HeatZoneType { urban, premium, peak }

class HeatZone {
  final LatLng center;
  final double intensity; // 0..1
  final HeatZoneType type;

  const HeatZone({
    required this.center,
    required this.intensity,
    this.type = HeatZoneType.urban,
  });
}

class DispatchJob {
  final String id;
  final String serviceName;
  final String customerName;
  final bool premium;
  final int payout;
  final LatLng location;

  // computed
  double distanceKm;
  int etaMin;
  double demandIntensity;
  double earningsEstimate;

  DispatchJob({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.premium,
    required this.payout,
    required this.location,
    this.distanceKm = 0,
    this.etaMin = 0,
    this.demandIntensity = 0,
    this.earningsEstimate = 0,
  });

  factory DispatchJob.fromSocketPayload(Map<String, dynamic> payload) {
    // Socket payload is placeholder; map it to a dispatch job.
    final jobId = (payload['jobId'] ?? UuidFallback()).toString();
    final type = (payload['type'] ?? 'General').toString();
    final payout = (payload['payout'] ?? 300).toString();

    double payoutInt = double.tryParse(payout) ?? 300;

    // Randomize around Delhi/NCR-ish coordinates for demo.
    final rnd = Random(jobId.hashCode);
    final lat = 28.4595 + (rnd.nextDouble() - 0.5) * 0.025;
    final lng = 77.0266 + (rnd.nextDouble() - 0.5) * 0.025;

    final premium = rnd.nextDouble() > 0.55;

    return DispatchJob(
      id: jobId,
      serviceName: type,
      customerName: premium ? 'Premium Customer' : 'Nearby Customer',
      premium: premium,
      payout: payoutInt.round(),
      location: LatLng(lat, lng),
    );
  }

  void updateComputedMetricsFromWorker({required Location workerLatLng}) {
    // Rough ops estimate:
    // - distance uses haversine
    // - ETA = distance / speed + demand
    distanceKm = _haversineKm(location, LatLng(workerLatLng.lat, workerLatLng.lng));

    // Speed estimate: 22km/h on average. Demand reduces ETA a bit.
    final baseSpeed = 22.0;
    etaMin = max(2, ((distanceKm / baseSpeed) * 60).round());

    // Slight premium reduces ETA.
    if (premium) etaMin = max(2, etaMin - 1);
  }

  double score(Location workerLatLng) {
    final distanceScore = 1.0 / max(0.6, distanceKm);
    final etaScore = 1.0 / max(1.0, etaMin);
    final demandScore = 1.0 + demandIntensity;
    final earningsScore = (earningsEstimate <= 0 ? payout.toDouble() : earningsEstimate);

    // Weighted ops scoring.
    return (etaScore * 2.2 + distanceScore * 1.4 + demandScore * 1.6) * (0.35 + earningsScore / 700);
  }

  static double _haversineKm(LatLng a, LatLng b) {
    const R = 6371.0;
    final dLat = (b.latitude - a.latitude) * pi / 180.0;
    final dLng = (b.longitude - a.longitude) * pi / 180.0;
    final la1 = a.latitude * pi / 180.0;
    final la2 = b.latitude * pi / 180.0;
    final h =
        sin(dLat / 2) * sin(dLat / 2) + cos(la1) * cos(la2) * sin(dLng / 2) * sin(dLng / 2);
    return 2 * R * asin(sqrt(h));
  }
}

class UuidFallback {
  @override
  String toString() => 'uuid_${DateTime.now().microsecondsSinceEpoch}';
}

