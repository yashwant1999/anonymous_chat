import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Material(
          //   borderRadius: BorderRadius.circular(5),
          //   color: Colors.amber,
          //   child: Padding(
          //     padding: const EdgeInsets.all(1.0),
          //     child:
          Text(
            sender.replaceFirst(RegExp(r"\@[^]*"), ""),
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          // ),
          // ),
          Material(
            shadowColor: Colors.black54,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 30 : 0),
                topRight: Radius.circular(isMe ? 0 : 30),
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30)),
            elevation: 5.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                )),
          ),
        ],
      ),
    );
  }
}
