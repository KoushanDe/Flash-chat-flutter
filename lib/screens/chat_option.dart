import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flash_chat/components/errormessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatOption extends StatefulWidget {
  static const String id = '/chatoption';
  @override
  _ChatOptionState createState() => _ChatOptionState();
}

class _ChatOptionState extends State<ChatOption> {
  final _auth = FirebaseAuth.instance;
  bool sameId = false;
  bool idNotFound = false;
  String chatId;
  String personId;
  int showLoading = 1;
  List<String> usersList = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUsers();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
        setState(() {});
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void getUsers() async {
    final users =
        await _firestore.collection('master_user_445223').getDocuments();
    for (var user in users.documents) {
      {
        usersList.add(user.data['userid']);
      }
    }
    setState(() {
      showLoading = 0;
    });
  }

  Color selectSpinkitColour(int load) {
    if (load == 0)
      return Colors.lightBlue;
    else if (load == 1)
      return Colors.blue[800];
    else
      return Colors.red[300];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
        leading: SpinKitRing(
          lineWidth: 2.0,
          color: selectSpinkitColour(showLoading),
          size: 20.0,
        ),
        title: Text(
          '⚡️Welcome: ${loggedInUser.email}',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              iconSize: 30.0,
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                // messagesStream();
              }),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              buttonTitle: 'Enter public chat',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              chatId: 'messages',
                              pvtid: '⚡️Public chat',
                            )));
              },
            ),
            ErrorMessage(
              visible: idNotFound || sameId,
              text: sameId
                  ? 'Cannot create/join private chat with yourself'
                  : 'User ID does not exist',
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              //textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                personId = value.toLowerCase();
              },
              style: TextStyle(color: Colors.grey[900]),
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter their user email (___@___.com)'),
            ),
            RoundedButton(
              color: Colors.blueAccent,
              buttonTitle: 'Enter private chat',
              onTap: () {
                sameId = false;
                idNotFound = false;
                bool found = false;
                for (String id in usersList) {
                  if (id == personId) {
                    found = true;
                    break;
                  }
                }
                if (personId == loggedInUser.email) {
                  setState(() {
                    sameId = true;
                  });
                  return;
                }
                if (found == true) {
                  if (loggedInUser.email.compareTo(personId) == -1)
                    chatId = loggedInUser.email + personId;
                  else if (loggedInUser.email.compareTo(personId) == 1)
                    chatId = personId + loggedInUser.email;

                  setState(() {
                    //implemented for a bug where it shows error even after giving correct id
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                chatId: chatId,
                                pvtid: '⚡️$personId',
                              )));
                } else
                  setState(() {
                    idNotFound = true;
                  });
              },
            ),
          ],
        ),
      ),
    );
  }
}
