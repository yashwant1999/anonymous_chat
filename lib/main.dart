import 'package:anonymous_chat/src/features/authenctication/login/login_screen.dart';
import 'package:anonymous_chat/src/features/authenctication/register/registration_screen.dart';
import 'package:anonymous_chat/src/features/authenctication/welcome_screen.dart';
import 'package:anonymous_chat/src/features/groups/screens/topic_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          // ChatScreen.id: (context) => const ChatScreen(),
          TopicScreen.id: ((context) => const TopicScreen())
        });
  }
}
