import 'package:anonymous_chat/src/features/groups/screens/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:anonymous_chat/src/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Flexible(
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Icon(
                    Icons.chat,
                    size: 100,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) async {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email')),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Password')),
            const SizedBox(
              height: 24.0,
            ),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: () async {
                try {
                  await _auth.signInWithEmailAndPassword(
                      email: email.trim(), password: password.trim());
                  _btnController.success();
                  await Future.delayed(const Duration(seconds: 1));
                  _btnController.reset();

                  if (!mounted) return;
                  Navigator.pushNamed(context, TopicScreen.id);
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                  _btnController.error();
                  await Future.delayed(const Duration(seconds: 1));
                  _btnController.reset();
                }
              },
              color: Colors.blueAccent,
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
