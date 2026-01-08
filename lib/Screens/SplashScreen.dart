import "dart:async";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      // Check if user is already logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in → Go to Home
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        // User not logged in → Go to Login
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Pure white
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: Image.asset(
            "assets/images/LensifySplash.jpg",
            fit: BoxFit.contain, // Shows full image without cutting
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}