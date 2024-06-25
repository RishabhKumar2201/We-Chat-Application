import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/api/apis.dart';
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

      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          final list = [];

          if(snapshot.hasData){
            final data = snapshot.data?.docs;
            for(var i in data!){
                  log('Data: ${jsonEncode(i.data())}');
                  list.add(i.data()['name']);
            }
          }

          return ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(top: mq.height * 0.01),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                //return const ChatUserCard();
                return Text('Name: ${list[index]}');
              });
        },
      ),
    );
  }
}
