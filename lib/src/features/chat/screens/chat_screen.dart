import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../widgets/message_bubble.dart';
import '../widgets/message_text_field.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;
bool incognito = false;
final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'chart_screen';
  final String collectiontopic;
  final String whocreated;

  const ChatScreen({
    super.key,
    required this.collectiontopic,
    required this.whocreated,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final messageTextController = TextEditingController();

  late Stream stream;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    stream = _firestore
        .collection(widget.collectiontopic)
        .orderBy('timestamp')
        .snapshots();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        elevation: 2,
        title: Text(
            '⚡️${widget.collectiontopic} by ${widget.whocreated.replaceFirst(RegExp(r"\@[^]*"), "")}'),
        backgroundColor: incognito ? Colors.blueGrey : Colors.blue,
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  incognito = incognito ? false : true;
                });
              },
              child: incognito
                  ? const Icon(
                      FluentIcons.incognito_20_filled,
                      color: Colors.white,
                    )
                  : const Icon(
                      FluentIcons.people_12_filled,
                      color: Colors.white,
                    )),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              stream: stream,
            ),
            MessageTextField(
              messageTextController: messageTextController,
              collectiontopic: widget.collectiontopic,
              whocreated: widget.whocreated,
              messageText: messageText,
              onPressed: () {
                messageTextController.clear();
                _firestore.collection(widget.collectiontopic).add(
                  {
                    'sneder': incognito
                        ? loggedInUser!.email == widget.whocreated
                            ? loggedInUser!.email
                            : 'Anonymous'
                        : loggedInUser!.email,
                    'real': loggedInUser!.email,
                    'text': messageText,
                    'timestamp': FieldValue.serverTimestamp(),
                  },
                );
              },
              onChanged: (value) {
                messageText = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key, required this.stream});
  final Stream stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center();
        }
        final messages = snapshot.data!.docs.reversed;
        List messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSneder = message.data()['sneder'];
          final realIndentity = message.data()['real'];
          final currentUser = loggedInUser?.email;

          final messageBubble = MessageBubble(
            sender: messageSneder,
            text: messageText,
            isMe: realIndentity == currentUser,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView.builder(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              physics: const BouncingScrollPhysics(),
              itemCount: messageBubbles.length,
              itemBuilder: (context, index) {
                return messageBubbles[index];
              }),
        );
      },
    );
  }
}
