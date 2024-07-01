import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<
      FormState>(); //for checking whether entry in form has been changed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

          //Floating button to log out user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                //For showing progress dialog
                Dialogs.showProgressBar(context);

                //Sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {});

                  //For hiding progress dialog
                  Navigator.pop(context);

                  //For moving home screen
                  Navigator.pop(context);

                  //Replacing home screen to login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
                // APIs.auth.signOut();
                // GoogleSignIn().signOut();
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(
                Icons.logout_outlined,
                size: 26,
                color: Colors.white,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          // Used to fetch data simultaneously from database
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //For adding some space
                    SizedBox(width: mq.width, height: mq.height * 0.05),

                    Stack(children: [
                      //Profile image
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

                      //Edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          shape: const CircleBorder(),
                          onPressed: () {
                            _showBottomSheet();
                          },
                          elevation: 2,
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),

                    //For adding some space
                    SizedBox(height: mq.height * 0.03),

                    //User email label
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),

                    //For adding some space
                    SizedBox(height: mq.height * 0.05),

                    //Input field of User Name section
                    TextFormField(
                        initialValue: widget.user.name,
                        onChanged: (val) =>
                            APIs.me.name = val ?? "", //to update the value
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Feild', //to show warning if null value is passed

                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.blue),
                            hintText: 'eg. User Name',
                            label: Text(
                              'Name',
                              style: TextStyle(fontSize: mq.height * 0.023),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),

                    //For adding more space
                    SizedBox(height: mq.height * 0.03),

                    // Input field of About section
                    TextFormField(
                        initialValue: widget.user.about,
                        onChanged: (val) =>
                            APIs.me.about = val ?? "", //to update the value
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field', //to show warning if null value is passed

                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.info_outline,
                                color: Colors.blue),
                            hintText: 'eg. Feeling Happy!',
                            label: Text(
                              'About',
                              style: TextStyle(fontSize: mq.height * 0.023),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),

                    //for adding more space
                    SizedBox(height: mq.height * 0.05),

                    //Button for updating profile
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: StadiumBorder(),
                          minimumSize: Size(mq.width * 0.5, mq.height * 0.06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile updated successfully!');
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 26,
                      ),
                      label: Text(
                        'UPDATE',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  //bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap:
                true, //it cover only the area which is required to by the content of ListView
            padding: EdgeInsets.only(
                top: mq.height * 0.02, bottom: mq.height * 0.07),
            children: [
              const Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),

              SizedBox(
                height: mq.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(mq.width * 0.3 , mq.height * 0.15)
                    ),
                      onPressed: (){},
                      child: Image.asset('images/add_image.png')),

                  //pick from camera capturing button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * 0.3 , mq.height * 0.15)
                      ),
                      onPressed: (){},
                      child: Image.asset('images/camera.png'))

                ],
              )
            ],
          );
        });
  }
}
