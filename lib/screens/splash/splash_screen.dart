import 'dart:async';
import 'package:flutter/material.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// LOGO
          Center(
            child: Image.asset(
              'assets/images/logo.png', // ganti sesuai nama file logo
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 40),

          /// LOADING TEXT
          const Text(
            'Loading...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
