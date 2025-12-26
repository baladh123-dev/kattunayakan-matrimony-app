import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0612), // Deep Rose Dark
              Color(0xFF2D1124), // Rose Dark
              Color(0xFF1F0D16), // Dark Rose
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFD4145A).withOpacity(0.15), // Rose
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFFD700).withOpacity(0.1), // Gold
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with glow effect
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD4145A).withOpacity(0.4),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Color(0xFFFFD700).withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFFD4145A).withOpacity(0.4),
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFD4145A).withOpacity(0.15),
                            Color(0xFFFFD700).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 80,
                        color: Color(0xFFFFD700), // Gold
                      ),
                    ),
                  ),

                  SizedBox(height: 50),

                  // Main title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFFFD700), // Gold
                        Color(0xFFD4145A), // Rose
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'காட்டு நாயக்கன்',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                        height: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // Subtitle with accent line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFFD4145A).withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'சமுதாயம்',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4145A).withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 80),

                  // Loading indicator with gradient
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD4145A).withOpacity(0.2),
                          Color(0xFFFFD700).withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFD700), // Gold
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 100),

                  // Tagline with elegant styling
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFFD4145A).withOpacity(0.3),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD4145A).withOpacity(0.1),
                          Color(0xFFFFD700).withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Matrimony app',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
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
      ),
    );
  }
}