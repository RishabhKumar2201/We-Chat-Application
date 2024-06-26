import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text(
          "We Chat",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
        ),
        actions: [
          //Search user button
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),

          //More feature button
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),

      //Floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            //Sign out function
            _signOut() async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            }
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),

      // Used to fetch data simultaneously from database
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            //If some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              //Store the data in form of list (The syntax works like for loop only)
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: mq.height * 0.01),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                      //return Text('Name: ${list[index]}');
                    });
              }
              else{
                return const Center(
                  child: Text("No connection found!", style: TextStyle(
                    fontSize: 20
                  ),),
                );
              }
          }
        },
      ),
    );
  }
}
