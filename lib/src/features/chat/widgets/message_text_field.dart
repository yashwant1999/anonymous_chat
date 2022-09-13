import 'package:flutter/material.dart';
import 'package:anonymous_chat/src/constants/constants.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.messageTextController,
    required this.collectiontopic,
    required this.whocreated,
    required this.messageText,
    this.onPressed,
    required this.onChanged,
  });

  final TextEditingController messageTextController;
  final String collectiontopic;
  final String whocreated;
  final String? messageText;
  final void Function()? onPressed;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageTextController,
              onChanged: onChanged,
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      // Change your radius here
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                onPressed: onPressed,
                child: const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 213, 239, 251),
                )),
          ),
        ],
      ),
    );
  }
}
