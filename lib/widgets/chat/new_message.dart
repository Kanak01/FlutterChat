import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    
    final userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) => value.data()!["username"]);

    final userImageUrl = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value.data()!["image_url"]);

    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userName.toString(),
      'userImage': userImageUrl.toString(), 
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF112d4e),//Color(0xFF2d4059),
      margin: EdgeInsets.only(top: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
         mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
