import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart'; // Ils sont dans le même dossier, donc ça marche !

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
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7F13EC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120, width: 120,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag, size: 60, color: Color(0xFF7F13EC)),
            ),
            const SizedBox(height: 24),
            const Text("IvoireMode", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white)
          ],
        ),
      ),
    );
  }
}