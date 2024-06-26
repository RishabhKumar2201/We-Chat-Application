import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

//Card to represent a single user on Home Screen
class ChatUserCard extends StatefulWidget {

  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02 , vertical: 4),
      elevation: 1,
      //color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          //user profile picture
          leading: /*CircleAvatar(child: Icon(CupertinoIcons.person))*/
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.40),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              height: mq.height * 0.050,
              width: mq.width * 0.095,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          //user name
          title: Text(widget.user.name),
          //last message
          subtitle: Text(widget.user.about, maxLines: 1,),
          //last message time
          trailing: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.5),
              color: Colors.green.shade400
            ),
          )
          // Text('12:00 PM', style: TextStyle(
          //     color: Colors.black54
          // ),),
        ),
      ),
    );
  }
}
