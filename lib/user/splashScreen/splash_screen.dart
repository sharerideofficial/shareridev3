import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_app/user/authentication/google_login_controller.dart';
import '/user/authentication/login_screen.dart';
import '/user/global/global.dart';
import '/user/mainScreens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GoogleSignInController _googleSignInController = new GoogleSignInController();
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      print(await fAuth.currentUser);

      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        currentUid = currentFirebaseUser!.uid;
        // Send user to Main Screen
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        // Send user to login Screen
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.orange])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/logo1.png'),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Share Ride App",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              const Text(
                "Made for community by kpriet students",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
