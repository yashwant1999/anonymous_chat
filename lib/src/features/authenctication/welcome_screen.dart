import 'package:flutter/material.dart';
import 'package:anonymous_chat/src/features/authenctication/login/login_screen.dart';
import 'package:anonymous_chat/src/features/authenctication/register/registration_screen.dart';
import 'package:anonymous_chat/src/common/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller!);
    controller?.forward();

    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation?.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: const <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    // ignore: sort_child_properties_last
                    child: Icon(Icons.chat),
                    height: 60.0,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Anonymous Chat',
                  style: TextStyle(
                      fontSize: 35.0,
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              onPressed: () {
                //Go to registration screen.
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: 'Register',
              color: Colors.blue,
            ),
            RoundedButton(
              onPressed: () {
                //Go to registration screen.
                Navigator.pushNamed(context, LoginScreen.id);
              },
              title: 'Login',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
