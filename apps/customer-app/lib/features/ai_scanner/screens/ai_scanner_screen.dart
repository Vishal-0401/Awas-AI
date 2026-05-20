import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/config/app_theme.dart';

class AiScannerScreen extends StatefulWidget {
  const AiScannerScreen({super.key});

  @override
  State<AiScannerScreen> createState() => _AiScannerScreenState();
}

class _AiScannerScreenState extends State<AiScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _startAnalysis() async {
    setState(() => _isAnalyzing = true);
    
    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() => _isAnalyzing = false);
      context.push('/diagnostic-result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview Placeholder
          Container(
            color: const Color(0xFF111111),
            child: const Center(
              child: Icon(Icons.camera_alt_outlined, color: Colors.white24, size: 100),
            ),
          ),
          
          // Scanner UI Overlay
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16),
                            SizedBox(width: 8),
                            Text('AI Vision Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: -0.5, end: 0),
                      IconButton(
                        icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Scanning Reticle
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        // Reticle Corners
                        ..._buildReticleCorners(),
                        
                        // Animated Scan Line
                        AnimatedBuilder(
                          animation: _scanController,
                          builder: (context, child) {
                            return Positioned(
                              top: _scanController.value * 280,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.8),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        // AI Targeting Points (Random dots)
                        if (_isAnalyzing)
                          ...List.generate(5, (index) => Positioned(
                            top: 40.0 * index + 20,
                            left: 50.0 * index + 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(duration: 500.ms),
                          )),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Controls
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isAnalyzing ? 'Analyzing appliance components...' : 'Point camera at the appliance issue',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ).animate(target: _isAnalyzing ? 1 : 0).fade(),
                      
                      const SizedBox(height: 32),
                      
                      GestureDetector(
                        onTap: _isAnalyzing ? null : _startAnalysis,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: _isAnalyzing ? 40 : 64,
                              height: _isAnalyzing ? 40 : 64,
                              decoration: BoxDecoration(
                                color: _isAnalyzing ? AppColors.error : Colors.white,
                                borderRadius: BorderRadius.circular(_isAnalyzing ? 8 : 32),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReticleCorners() {
    const double length = 40;
    const double thickness = 4;
    final color = AppColors.primary.withOpacity(0.8);
    
    return [
      // Top Left
      Positioned(top: 0, left: 0, child: Container(width: length, height: thickness, color: color)),
      Positioned(top: 0, left: 0, child: Container(width: thickness, height: length, color: color)),
      // Top Right
      Positioned(top: 0, right: 0, child: Container(width: length, height: thickness, color: color)),
      Positioned(top: 0, right: 0, child: Container(width: thickness, height: length, color: color)),
      // Bottom Left
      Positioned(bottom: 0, left: 0, child: Container(width: length, height: thickness, color: color)),
      Positioned(bottom: 0, left: 0, child: Container(width: thickness, height: length, color: color)),
      // Bottom Right
      Positioned(bottom: 0, right: 0, child: Container(width: length, height: thickness, color: color)),
      Positioned(bottom: 0, right: 0, child: Container(width: thickness, height: length, color: color)),
    ];
  }
}
