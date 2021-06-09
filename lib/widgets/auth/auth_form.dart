import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  late File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    // ignore: unnecessary_null_comparison
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome to Flutter Chat 💬.',
                    speed: Duration(milliseconds: 300),
                    textStyle: GoogleFonts.merriweatherSans(
                      textStyle: Theme.of(context).textTheme.headline1,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 18,
              color: Color(0xFF1F4068),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (!_isLogin) UserImagePicker(_pickedImage),
                        TextFormField(
                          cursorColor: Color(0xFF0F3460),
                          key: ValueKey('email'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value!.isEmpty || !value.endsWith('@fchat.com')) {
                              return 'Enter a valid email address with @fchat.com';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email address',
                          ),
                          onSaved: (value) {
                            _userEmail = value!;
                          },
                        ),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('username'),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Username'),
                            onSaved: (value) {
                              _userName = value!;
                            },
                          ),
                        TextFormField(
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          onSaved: (value) {
                            _userPassword = value!;
                          },
                        ),
                        SizedBox(height: 12),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          RaisedButton(
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                            onPressed: _trySubmit,
                          ),
                        if (!widget.isLoading)
                          TextButton(
                            child: Text(_isLogin
                                ? 'Create new account'
                                : 'I already have an account'),
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
