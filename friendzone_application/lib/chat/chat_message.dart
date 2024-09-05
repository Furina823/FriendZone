import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../chat/chat_detail.dart';
import '../model/user.dart';
import '../model/chatparticipant.dart';
import '../model/message.dart';

class ChatMessage extends StatefulWidget {
  final String own_user_id;
  final String other_user_id;
  final String chat_id;

  const ChatMessage(
      {super.key,
      required this.own_user_id,
      required this.other_user_id,
      required this.chat_id});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  late Future<User> futureUser;
  late Future<List<Message>> futureMessages;
  late Future<ChatParticipant> futureChatParticipant;
  final TextEditingController chatController = TextEditingController();

  String formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown Time';
    return DateFormat('HH:mm').format(dateTime);
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown Date';
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  void _refreshData() {
    setState(() {
      futureUser = fetchUser(widget.other_user_id);
      futureMessages = fetchMessages();
      futureChatParticipant = fetchChatParticipant(widget.chat_id);
    });
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(widget.other_user_id);
    futureMessages = fetchMessages();
    futureChatParticipant = fetchChatParticipant(widget.chat_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_left_sharp, size: 50),
                  color: Color(0xff4C315C),
                ),
                backgroundColor: Colors.white,
                title: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_left_sharp, size: 50),
                  color: Color(0xff4C315C),
                ),
                backgroundColor: Colors.white,
                title: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData) {
              return AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_left_sharp, size: 50),
                  color: Color(0xff4C315C),
                ),
                backgroundColor: Colors.white,
                title: Center(child: Text('No Data Available')),
              );
            } else {
              User user = snapshot.data!;
              return AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_left_sharp, size: 50),
                  color: Color(0xff4C315C),
                ),
                backgroundColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: user.profile_picture != null
                            ? AssetImage(
                                "images/profile/${user.profile_picture}")
                            : AssetImage("images/profile/default.jpg")
                                as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.nickname ?? "Unknown",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff4C315C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetail(
                              user_id: widget.other_user_id,
                              chat_id: widget.chat_id,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Color(0xff4C315C),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      backgroundColor: Color(0xffE9E6EB),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: FutureBuilder<ChatParticipant>(
          future: futureChatParticipant,
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (chatSnapshot.hasError) {
              return Center(child: Text('Error: ${chatSnapshot.error}'));
            } else if (!chatSnapshot.hasData) {
              return Center(child: Text('Chat not found.'));
            } else {
              final chatParticipant = chatSnapshot.data!;

              return FutureBuilder<List<Message>>(
                future: futureMessages,
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (messageSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${messageSnapshot.error}'));
                  } else if (!messageSnapshot.hasData ||
                      messageSnapshot.data!.isEmpty) {
                    return Center(child: Text('No messages yet.'));
                  } else {
                    final messages = messageSnapshot.data!
                        .where((message) =>
                            message.chat_id == chatParticipant.chat_id)
                        .toList();

                    // Group messages by date
                    final groupedMessages = <DateTime, List<Message>>{};
                    for (final message in messages) {
                      final dateTime = message.date_time;
                      if (dateTime == null) continue;

                      final date = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                      );
                      if (!groupedMessages.containsKey(date)) {
                        groupedMessages[date] = [];
                      }
                      groupedMessages[date]!.add(message);
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            reverse: true,
                            children: groupedMessages.entries.map((entry) {
                              final date = entry.key;
                              final messages = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Center(
                                      child: Text(
                                        formatDate(date),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...messages.map((message) {
                                    final isOwnMessage =
                                        message.user_id.toString() ==
                                            widget.own_user_id;

                                    return isOwnMessage
                                        ? OwnMessageCard(
                                            message: message.message_text!,
                                            time:
                                                formatTime(message.date_time!),
                                          )
                                        : ReplyMessageCard(
                                            message: message.message_text!,
                                            time:
                                                formatTime(message.date_time!),
                                          );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  width: 300,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      style:
                                          TextStyle(color: Color(0xff4C315C)),
                                      controller: chatController,
                                      decoration: InputDecoration(
                                        hintText: 'Type Something...',
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff747474)),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                      ),
                                      maxLines: 1,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () async{
                                  DateTime now = DateTime.now();

                                  createMessage(
                                      widget.chat_id,
                                      widget.own_user_id,
                                      chatController.text,
                                      now);

                                  chatController.clear();

                                  setState(() {
                                    _refreshData();
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Color(0xff4C315C),
                                  radius: 30,
                                  child: Image.asset(
                                    "icons/send.png",
                                    color: Colors.white,
                                    width: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({Key? key, required this.message, required this.time})
      : super(key: key);

  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 3),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Color(0xff4C315C),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyMessageCard extends StatelessWidget {
  const ReplyMessageCard({Key? key, required this.message, required this.time})
      : super(key: key);

  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3),
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
