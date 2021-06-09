import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_chat_app/widgets/chat/messages.dart';
import 'package:group_chat_app/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF112d4e),
          title: Text(
            'Flutter Chat',
            style: GoogleFonts.merriweatherSans(
              textStyle: Theme.of(context).textTheme.headline1,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: Color(0xFFdbe2ef),
            ),
          ),
          actions: [
            DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app_rounded,
                            color: Colors.blueGrey.shade900),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                )
              ],
              onChanged: (itemIdentifier) {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
        body: Container(
          color: Color(0xFF3F72AF),
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
