import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

// View Profile screen -- to view profile of using i am chatting with
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //appBar
          appBar: AppBar(
            title: Text(
              widget.user.name,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 19),
            ),
          ),

          floatingActionButton:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Joined On: ' , style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
              ),),
              Text(
                MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt, showYear: true),
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),

          // Used to fetch data simultaneously from database
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //For adding some space
                  SizedBox(width: mq.width, height: mq.height * 0.05),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.40),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
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

                  //User email label
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),

                  //For adding some space
                  SizedBox(height: mq.height * 0.02),

                  // user about section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('About: ' , style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),),
                      Text(
                        widget.user.about,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          )),
    );
  }
}
