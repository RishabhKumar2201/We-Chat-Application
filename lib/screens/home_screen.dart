import 'package:flutter/material.dart';

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
        title: Text("We Chat", style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),),

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
          onPressed: (){},
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
    );
  }
}
