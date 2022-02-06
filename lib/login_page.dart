import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:group_chat/preferences.dart';
import 'package:group_chat/rounded_button.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import 'chat_screen.dart';
import 'constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String? email;
  late String? password;
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    email = Preferences.getUserEmail();
    password = Preferences.getUserPassword();
    if (email != null && password != null) {
      logInWithEmailAndPassword(context).whenComplete(() => null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        leading: const Icon(
          Icons.chat,
          color: Colors.blue,
          size: 30,
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.lightBlueAccent,
        title: const Text(
          'Group Chat',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: const SpinKitDoubleBounce(
          size: 250,
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                textInputAction: TextInputAction.done,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.vpn_key),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  await logInWithEmailAndPassword(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logInWithEmailAndPassword(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());

      Preferences.setUserEmail(email!);
      Preferences.setUserPassword(password!);
      Navigator.pushNamed(context, ChatScreen.id);

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
