import 'package:chatting_app/main.dart';
import 'package:chatting_app/screens/auth/login_screen.dart';
import 'package:chatting_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    bool _isAnimated = false;
    return Scaffold(
      body: Stack(children: [
        Positioned(
            top: mq.height * 0.15,
            width: mq.width * 0.5,
            left: mq.width * .25,
            child: Image.asset('images/icon.png')),
        Positioned(
            bottom: mq.height * 0.15,
            width: mq.width * 0.9,
            child: const Text(
              'Made by Rajeel Ansari',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Colors.black, letterSpacing: .5),
            )),
      ]),
    );
  }
}
