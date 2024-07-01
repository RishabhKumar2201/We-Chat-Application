import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},

      child: Row(
        children: [
          //back button
          IconButton(onPressed: (){
            Navigator.pop(context);
          },
              icon: Icon(Icons.arrow_back, color: Colors.black54,)),

          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.40),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              height: mq.height * 0.045,
              width: mq.width * 0.095,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),

          SizedBox(
            width: 10,
          ),

          //showing user name and their last seen time (below)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user name
                  Text(widget.user.name, style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87
                  )),

              //last seen time of user
              Text('Last seen not available', style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13
              ),),
            ],
          )
        ],
      ),
    );
  }
}
