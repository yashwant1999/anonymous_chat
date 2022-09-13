import 'package:anonymous_chat/src/features/groups/screens/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:anonymous_chat/src/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool spinning = false;
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
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter youy Password')),
            const SizedBox(
              height: 24.0,
            ),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: () async {
                // print(email);
                // print(password);
                _btnController.start();

                try {
                  await _auth.createUserWithEmailAndPassword(
                      email: email.trim(), password: password.trim());
                  _btnController.success();
                  await Future.delayed(const Duration(seconds: 1));
                  _btnController.reset();

                  if (!mounted) return;
                  Navigator.pushNamed(context, TopicScreen.id);
                } catch (e) {
                  _btnController.error();
                  await Future.delayed(const Duration(seconds: 1));
                  _btnController.reset();
                }
              },
              color: Colors.blueAccent,
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
