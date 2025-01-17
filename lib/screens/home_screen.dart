import 'dart:developer';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> _list = [];

  final List<ChatUser> _searchList = []; //to store searched item

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();

    //for setting user status to Active
    APIs.updateActiveStatus(true);

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if(APIs.auth.currentUser != null){
        if(message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
         if(message.toString().contains('pause')){
           APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      //for hiding keyboard when tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),

      child: WillPopScope(
        //if search is on and back button is pressed then close search
        //or else simply close current screen on back button click
        onWillPop: () {
          if(_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          //appBar
          appBar: AppBar(
            leading: Icon(Icons.home),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: TextStyle(fontSize: 17, letterSpacing: 0.5),

                    //Search Functionality
                    onChanged: (val) {
                      //Searching logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }

                        //to update the search list after adding searched value
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text(
                    "We Chat",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 19),
                  ),
            actions: [
              //Search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              //More feature button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: Icon(Icons.more_vert))
            ],
          ),

          //Floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                //Sign out function

                APIs.auth.signOut();
                GoogleSignIn().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),

          // Used to fetch data simultaneously from database
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * 0.01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user:
                                  _isSearching ? _searchList[index] : _list[index]);
                          //return Text('Name: ${list[index]}');
                        });
                  } else {
                    return const Center(
                      child: Text(
                        "No connection found!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
