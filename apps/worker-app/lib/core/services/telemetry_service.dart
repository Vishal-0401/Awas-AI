import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorkerState { offline, online, available, busy, onJob }

class Location {
  final double lat;
  final double lng;
  Location(this.lat, this.lng);
}

class TelemetryState {
  final WorkerState workerState;
  final Location? currentLocation;

  TelemetryState({this.workerState = WorkerState.offline, this.currentLocation});

  TelemetryState copyWith({WorkerState? workerState, Location? currentLocation}) {
    return TelemetryState(
      workerState: workerState ?? this.workerState,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }
}

class TelemetryNotifier extends StateNotifier<TelemetryState> {
  Timer? _heartbeatTimer;
  final StreamController<Location> _locationStreamController = StreamController<Location>.broadcast();
  
  TelemetryNotifier() : super(TelemetryState());

  Stream<Location> get locationStream => _locationStreamController.stream;

  void toggleStatus() {
    if (state.workerState == WorkerState.offline) {
      state = state.copyWith(workerState: WorkerState.online);
      _startHeartbeat();
    } else {
      state = state.copyWith(workerState: WorkerState.offline);
      _stopHeartbeat();
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (state.workerState == WorkerState.offline) {
        timer.cancel();
        return;
      }
      
      // Simulate movement heartbeat
      final random = Random();
      final latOffset = (random.nextDouble() - 0.5) * 0.001;
      final lngOffset = (random.nextDouble() - 0.5) * 0.001;
      
      final currentLat = state.currentLocation?.lat ?? 37.7749; // Default SF
      final currentLng = state.currentLocation?.lng ?? -122.4194;
      
      final newLocation = Location(currentLat + latOffset, currentLng + lngOffset);
      
      state = state.copyWith(currentLocation: newLocation);
      _locationStreamController.add(newLocation);
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    state = state.copyWith(currentLocation: null);
  }

  @override
  void dispose() {
    _stopHeartbeat();
    _locationStreamController.close();
    super.dispose();
  }
}

final telemetryProvider = StateNotifierProvider<TelemetryNotifier, TelemetryState>((ref) {
  return TelemetryNotifier();
});
