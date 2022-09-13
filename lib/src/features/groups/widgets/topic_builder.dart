import 'package:flutter/material.dart';
import 'package:anonymous_chat/src/features/chat/screens/chat_screen.dart';

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
