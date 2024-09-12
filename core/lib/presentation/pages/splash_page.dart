import 'dart:async';

import '../../core.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    loadSplashScreen();
  }

  Future<Timer> loadSplashScreen() async {
    return Timer(
      const Duration(seconds: 3),
      route,
    );
  }

  void route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: kMikadoYellow,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                "assets/splash.gif",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Dive into the World of Movies & TV Series",
            style: kSubtitle,
          ),
        ],
      )),
    );
  }
}
