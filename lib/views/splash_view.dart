import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/app_router.dart';
import '../constants/app_constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeIn;
  late Animation<double> _scale;
  late Animation<double> _rotate;
  late Animation<double> _floating;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // Rotate animation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _rotate = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotateController,
        curve: Curves.easeInOut,
      ),
    );

    // Floating animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floating = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _rotateController.forward();

    // Navigate after delay
    Timer(const Duration(milliseconds: 3500), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding =
            prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;

        if (hasSeenOnboarding) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F0F1E),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Orbs
            AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 100 + _floating.value,
                      right: 30,
                      child: _buildFloatingOrb(
                        size: 150,
                        color: const Color(0xFF667eea),
                      ),
                    ),
                    Positioned(
                      bottom: 150 - _floating.value,
                      left: -20,
                      child: _buildFloatingOrb(
                        size: 200,
                        color: const Color(0xFFf093fb),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.5 + _floating.value * 0.5,
                      right: -40,
                      child: _buildFloatingOrb(
                        size: 120,
                        color: const Color(0xFF4ECDC4),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Grid Pattern Overlay
            CustomPaint(
              size: Size(size.width, size.height),
              painter: GridPatternPainter(),
            ),

            // Main Content
            Center(
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    ScaleTransition(
                      scale: _scale,
                      child: RotationTransition(
                        turns: _rotate,
                        child: Hero(
                          tag: 'app_icon',
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF667eea),
                                  Color(0xFF764ba2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF667eea).withOpacity(0.6),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome_outlined,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // App Name with Gradient
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFf093fb),
                          Color(0xFF667eea),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        "Loan Advisor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tagline
                    Text(
                      "AI-Powered Financial Assistant",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Modern Loading Indicator
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          // Outer ring
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF667eea).withOpacity(0.3),
                              ),
                            ),
                          ),
                          // Inner spinning ring
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF667eea),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Loading Text
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Text(
                        "Initializing...",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Version/Credits at bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  children: [
                    Text(
                      "Powered by Advanced AI",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.2),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingOrb({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.1),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}