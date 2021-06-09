import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/screens/auth_screen.dart';
import 'package:group_chat_app/screens/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
          title: 'Flutter Chat',
          theme: ThemeData(
            backgroundColor: Color(0xFF162447),
            accentColor: Colors.blueGrey.shade900,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Color(0xFF17202A),
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: appSnapshot.connectionState != ConnectionState.done
              ? FlutterLogo(
                size: 100,
                textColor: Colors.blueGrey,
                style: FlutterLogoStyle.horizontal,
                duration: Duration(seconds: 7),
                curve: Curves.bounceInOut,
              )
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasData) {
                      return ChatScreen();
                    }
                    return AuthScreen();
                  },
                ),
        );
      },
    );
  }
}


