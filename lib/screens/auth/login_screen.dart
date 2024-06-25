import 'dart:developer';
import 'dart:io';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helper/dialogs.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick(){
    //For showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user){

      // For removing progress bar
      Navigator.pop(context);

      if(user != null){
        print("User Credentials: ${user.credential}");
        print("User info: ${user.user}");
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }

    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle : $e');
      Dialogs.showSnackbar(context, 'Something went wrong (Check internet');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;

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
          AnimatedPositioned(
              top: mq.height * .15, //15% from top
              right: _isAnimate ? mq.width * .15 : -mq.width * .5,
              width: mq.width * .70,
              duration: Duration(milliseconds: 1500),
              child: Image.asset('images/icon.png')),

          //Google login button
          Positioned(
              bottom: mq.height * .20, //15% from top
              left: mq.width * .05, //25% from left
              width: mq.width * .9, //50% total width
              height: mq.height * .07,
              child: ElevatedButton.icon(
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: StadiumBorder(),
                      elevation: 5),

                  //Google icon
                  icon: Image.asset("images/google.png",
                      height: mq.height * .035),
                  label: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: [
                          TextSpan(text: "Sign In with "),
                          TextSpan(
                              text: "Google",
                              style: TextStyle(fontWeight: FontWeight.w500))
                        ]),
                  )))
        ],
      ),
    );
  }
}
