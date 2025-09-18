// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:buck/components/bottom_navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Use a TickerProvider to manage the animation controller
  late AnimationController _controller;
  // Use an Animation for the scaling effect of the logo
  late Animation<double> _scaleAnimation;
  // Use a double for the opacity to create a fade-in effect
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Initialize the scaling animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the fade-in and scaling animations
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
      _controller.forward();
    });

    // Navigate to the next screen after a delay
    // This simulates the time needed for the app to initialize
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const CustomBottomNavigationBar(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Add a gradient background for a modern look
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 0, 62, 197),
              const Color.fromARGB(255, 86, 193, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use AnimatedOpacity for a fade-in effect
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 1),
                child: ScaleTransition(
                  
                  scale: _scaleAnimation,
                
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      // You must add your image to the assets folder and pubspec.yaml
                      'assets/images/logo.png',
                      
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Use AnimatedOpacity for a delayed fade-in effect
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 1),
                child: Column(
                  children: [
                    Text(
                      'صحيح البخاري',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                        // Add a slight shadow for a creative touch
                        shadows: [
                          Shadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'لمن أراد الهدي.. ومنبع العلم.. ودليل المسلمين',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
