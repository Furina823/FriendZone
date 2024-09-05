import 'package:flutter/material.dart';
import 'package:friendzone_application/model/message.dart';
import 'package:friendzone_application/model/user.dart';
import '../model/chatparticipant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MessagePage(
        chatId: "7",
        ownUserId: "40",
        other_user_id: "10",
      ),
    );
  }
}

class MessagePage extends StatefulWidget {
  final String chatId;
  final String ownUserId;
  final String other_user_id;

  const MessagePage({
    required this.chatId,
    required this.ownUserId,
    required this.other_user_id,
    Key? key,
  }) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late Future<List<Message>> futureMessages;
  late Future<ChatParticipant> futureChatParticipant;

  @override
  void initState() {
    super.initState();
    futureMessages = fetchMessages();
    futureChatParticipant = fetchChatParticipant(widget.chatId);
  }

  Future<User> fetchUserById(String userId) async {
    // You can replace this with the actual method to fetch a User by user_id
    return await fetchUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: FutureBuilder<ChatParticipant>(
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
                if (messageSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (messageSnapshot.hasError) {
                  return Center(child: Text('Error: ${messageSnapshot.error}'));
                } else if (!messageSnapshot.hasData || messageSnapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                } else {
                  final messages = messageSnapshot.data!
                      .where((message) => message.chat_id == chatParticipant.chat_id)
                      .toList();

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return FutureBuilder<User>(
                        future: fetchUserById(message.user_id.toString()),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text("Loading..."),
                              subtitle: Text(message.message_text!),
                              trailing: Text(message.date_time.toString()),
                            );
                          } else if (userSnapshot.hasError) {
                            return ListTile(
                              title: Text("Error"),
                              subtitle: Text(message.message_text!),
                              trailing: Text(message.date_time.toString()),
                            );
                          } else if (!userSnapshot.hasData) {
                            return ListTile(
                              title: Text("Unknown User"),
                              subtitle: Text(message.message_text!),
                              trailing: Text(message.date_time.toString()),
                            );
                          } else {
                            final user = userSnapshot.data!;
                            return ListTile(
                              title: Text(user.nickname ?? "Unknown"),
                              subtitle: Text(message.message_text!),
                              trailing: Text(message.date_time.toString()),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
