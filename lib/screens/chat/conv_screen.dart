import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;
class ConversationScreen extends StatefulWidget {


  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final messageTextController =TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Row(
          children: [
            Image.asset("assets/images/wewe.png", height: 25),
            SizedBox(width: 10),
            Text('Chat')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
             // messagesStreams();
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageSteamBuilder(),

            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText =value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':signedInUser.email,
                        'time':FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

      class MessageSteamBuilder extends StatelessWidget {
        const MessageSteamBuilder({Key? key}) : super(key: key);
      
        @override
        Widget build(BuildContext context) {
          return  StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('time').snapshots(),
              builder: (context,snapshot) {

                List<MessageLine> messageWidgets =[];
                if (!snapshot.hasData){
                  return Center (
                    child:CircularProgressIndicator(
                      backgroundColor:Colors.blue,
                    ),
                  );

                }
                final messages =snapshot.data!.docs;
                for(var message in messages){
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');
                  final currentUser = signedInUser.email;

                  final messageWidget =
                  MessageLine(
                      sender: messageSender,
                      text: messageText,
                    isMe: currentUser == messageSender,
                  );
                  messageWidgets.add (messageWidget);

                }
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),

                    children: messageWidgets,

                  ),
                );
              }
          );
        }
      }
      

    class MessageLine extends StatelessWidget {
      const MessageLine({this.text, this.sender,required this.isMe, Key? key}) : super(key: key);

      final String? sender;
      final String? text;
      final bool isMe;
    
      @override
      Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: [
              Text(
                  '$sender',
              style: TextStyle (fontSize: 12,color: Colors.black45),
              ),
              Material(
                elevation: 5,
                borderRadius: isMe? BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),

                ):BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),

                ),
                color:isMe? Colors.blue[800] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: Text
                    ('$text ',
                    style: TextStyle(fontSize: 15, color: isMe ?Colors.white : Colors.black54),
              ),
                ),
              ),
            ],
          )
        );
      }
    }
    
