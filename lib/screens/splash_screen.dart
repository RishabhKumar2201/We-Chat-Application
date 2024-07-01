import 'dart:developer';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      //Exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      //Set status bar color to transparent
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

      //Check if user is already signed in
      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //appBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome to We Chat",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
        ),
      ),

      //Body
      body: Stack(
        children: [
          //App Logo (Adding Animation to logo)
          Positioned(
              top: mq.height * .15, //15% from top
              right: mq.width * .15,
              width: mq.width * .70,
              child: Image.asset('images/icon.png')),

          // Welcome Text
          Positioned(
              bottom: mq.height * .20,
              width: mq.width,
              child: const Text(
                "Let's Chat ✨",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 29, color: Colors.black87, letterSpacing: 0.9),
              ))
        ],
      ),
    );
  }
}
