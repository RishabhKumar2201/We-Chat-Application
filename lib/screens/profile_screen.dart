import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

// Profile screen to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar
        appBar: AppBar(
          title: Text(
            "Profile Screen",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 19),
          ),
        ),

        //Floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () {
              //Sign out function

              APIs.auth.signOut();
              GoogleSignIn().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: const Icon(Icons.logout_outlined, size: 26,color: Colors.white,),
            label: const Text('Logout', style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),),
          ),
        ),

        // Used to fetch data simultaneously from database
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
          child: Column(
            children: [
              //For adding some space
              SizedBox(width: mq.width, height: mq.height * 0.05),

              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.40),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: mq.height * 0.2,
                  width: mq.width * 0.45,
                  //user profile picture
                  imageUrl: widget.user.image,
                  //placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),

              //For adding some space
              SizedBox(height: mq.height * 0.03),
              Text(
                widget.user.email,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),

              //For adding some space
              SizedBox(height: mq.height * 0.05),
              TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      hintText: 'eg. User Name',
                      label: Text(
                        'Name',
                        style: TextStyle(fontSize: mq.height * 0.023),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                      ))),

              SizedBox(height: mq.height * 0.03),

              TextFormField(
                  initialValue: widget.user.about,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info_outline, color: Colors.blue),
                      hintText: 'eg. Feeling Happy!',
                      label: Text(
                        'About',
                        style: TextStyle(fontSize: mq.height * 0.023),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),

              SizedBox(height: mq.height * 0.05),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: StadiumBorder(),
                  minimumSize: Size(mq.width * 0.5, mq.height * 0.06)
                ),
                  onPressed: (){},
                  icon: const Icon(Icons.edit, color: Colors.white,size: 26,),
                 label: Text('UPDATE', style: TextStyle(
                   color: Colors.white,
                   fontSize: 16
                 ),),)
            ],
          ),
        ));
  }
}
