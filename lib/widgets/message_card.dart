import 'package:chat_app/api/apis.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //sender or another user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          //Expanded covers entire space but flexible covers only required space between limits
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.03, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              color: Color.fromARGB(255, 221, 245, 255),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Text(
              widget.message.msg,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            widget.message.sent,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        )
      ],
    );
  }

  //our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * 0.04),

            // double tick blue icon for message read
            Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            // for adding some space
            const SizedBox(width: 2),

            //read time
            Text("${widget.message.read} 12:00 AM",
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),

        //message content
        Flexible(
          //Expanded covers entire space but flexible covers only required space between limits
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.03, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen),
              color: Color.fromARGB(255, 218, 255, 176),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
            ),
            child: Text(
              widget.message.msg,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
