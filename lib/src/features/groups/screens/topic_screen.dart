import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anonymous_chat/src/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:anonymous_chat/src/constants/constants.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});
  static const String id = 'topic_screen';

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen>
    with AutomaticKeepAliveClientMixin {
  final _auth = FirebaseAuth.instance;
  Stream? st;
  @override
  void initState() {
    st = _firestore.collection('topics').snapshots();
    super.initState();

    getCurrentUser();
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
            IconButton(
                icon: const Icon(Icons.cleaning_services),
                onPressed: () async {
                  var collectios = await _firestore.collection('topics').get();
                  for (var database in collectios.docs) {
                    await database.reference.delete();
                    var mores = await _firestore
                        .collection(database.data()['database'])
                        .get();
                    for (var more in mores.docs) {
                      await more.reference.delete();
                    }
                  }
                }),
          ],
          elevation: 2,
          centerTitle: true,
          title: const Text(
            // loggedInUser!.email.toString(),
            'Topics', style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TopicStreamBuilder(stream: st),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            shoeSimpleDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void shoeSimpleDialog(BuildContext context) {
    final TextEditingController topicTextController = TextEditingController();

    final TextEditingController imageUrlTextController =
        TextEditingController();

    void addTopicAndImageToFirbase() async {
      await _firestore.collection('topics').add({
        'database': topicTextController.value.text,
        'timestamp': FieldValue.serverTimestamp(),
        'createdBy': loggedInUser!.email,
        'imageUrl': imageUrlTextController.value.text
      });
      if (!mounted) return;
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        titlePadding: const EdgeInsets.all(12.0),
        title: Column(
          children: [
            TextField(
              controller: topicTextController,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter you topic name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: imageUrlTextController,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter you image url'),
            ),
            ElevatedButton(
                onPressed: () {
                  addTopicAndImageToFirbase();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${topicTextController.value.text} Topic Added')));
                },
                child: const Text('Done'))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TopicStreamBuilder extends StatelessWidget {
  const TopicStreamBuilder({
    super.key,
    required this.stream,
  });

  final Stream? stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final topics = snapshot.data!.docs.reversed;
        List<GroupTile> groupTile = [];

        for (var topicname in topics) {
          final docId = topicname.id;
          final topic = topicname.data()['database'];
          final userWhoCreated = topicname.data()['createdBy'];
          final imagUrl = topicname.data()['imageUrl'];
          final groupTiles = GroupTile(
            docId: docId,
            url: imagUrl,
            topics: topic,
            userWhoCreated: userWhoCreated,
          );
          groupTile.add(groupTiles);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return groupTile[index];
              }),
        );
      }),
    );
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile(
      {Key? key,
      required this.topics,
      required this.userWhoCreated,
      this.url,
      required this.docId})
      : super(key: key);
  final String userWhoCreated;
  final String topics;
  final String docId;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) {
            return ChatScreen(
              collectiontopic: topics.trim(),
              whocreated: userWhoCreated,
            );
          }),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Card(
            // borderRadius: BorderRadius.circular(10),
            elevation: 2,
            color: Colors.blue[300],
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          url ??
                              'https://staticg.sportskeeda.com/editor/2022/08/53e15-16596004347246.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text(
                        topics,
                        // textScaleFactor: 2,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(
                        'By $userWhoCreated',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
