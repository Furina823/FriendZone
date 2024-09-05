import 'package:flutter/material.dart';
import 'package:friendzone_application/model/chatparticipant.dart';
import 'package:friendzone_application/model/friend.dart';
import 'package:friendzone_application/model/message.dart';
import 'package:friendzone_application/model/user.dart';

import 'chat_message.dart';

class ChatHistory extends StatefulWidget {
  final String user_id; 
  const ChatHistory({super.key, required this.user_id});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  late Future<List<ChatParticipant>> futureChats;
  late Future<List<User>> futureUsers;
  late Future<List<Friend>> futureFriends;
  late Future<List<Message>> futureMessages; // Add this
  late Future<List<dynamic>> _future;

  void _refreshData() {
    setState(() {
      _future = Future.wait([
        fetchChatParticipants(),
        fetchFriends(),
        fetchUsers(),
        fetchMessages(), // Add this
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      fetchChatParticipants(),
      fetchFriends(),
      fetchUsers(),
      fetchMessages(), // Add this
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshData(); // Trigger data refresh
          await _future; // Wait until the data is refreshed
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder<List<dynamic>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Start Chatting with Friends Now!"));
              } else {
                final chats = snapshot.data![0] as List<ChatParticipant>;
                final friends = snapshot.data![1] as List<Friend>;
                final users = snapshot.data![2] as List<User>;
                final messages = snapshot.data![3] as List<Message>;

                // Filter friends based on the widget.user_id
                final friendIds = friends
                    .where((friend) =>
                        (friend.user_id.toString() == widget.user_id &&
                            friend.user_id_2.toString() != widget.user_id) ||
                        (friend.user_id_2.toString() == widget.user_id &&
                            friend.user_id.toString() != widget.user_id))
                    .map((friend) => friend.user_id.toString() == widget.user_id
                        ? friend.user_id_2.toString()
                        : friend.user_id.toString())
                    .toSet();

                // Filter users who are friends
                final filteredUsers = users.where((user) {
                  return friendIds.contains(user.user_id.toString());
                }).toList();

                // Find chat_id and last message for each filtered user
                final userWithChatData = filteredUsers.map((user) {
                  // Find the chat_id if either user of friend_id in friend table user_id, or user of friend_id_2 in friend table user_id
                  ChatParticipant? chatParticipant;

                  try {
                    chatParticipant = chats.firstWhere(
                      (chat) => friends.any(
                        (friend) =>
                            (friend.friend_id == chat.friend_id &&
                                ((friend.user_id.toString() == widget.user_id &&
                                    friend.user_id_2.toString() == user.user_id.toString()) ||
                                (friend.user_id.toString() == user.user_id.toString() &&
                                    friend.user_id_2.toString() == widget.user_id))),
                      ),
                    );
                  } catch (e) {
                    chatParticipant = null;
                  }

                  // Find the last message for the chat_id
                  final relevantMessages = messages
                      .where((msg) => msg.chat_id.toString() == chatParticipant?.chat_id.toString())
                      .where((msg) => msg.date_time != null) // Ensure date_time is not null
                      .toList();

                  Message? lastMessage;
                  if (relevantMessages.isNotEmpty) {
                    relevantMessages.sort((a, b) => b.date_time!.compareTo(a.date_time!)); // Sort messages by date_time
                    lastMessage = relevantMessages.first;
                  }

                  // Add "Me: " to the message text if the message is sent by widget.user_id
                  String messageText = lastMessage?.message_text ?? 'No messages yet';
                  if (lastMessage != null && lastMessage.user_id.toString() == widget.user_id) {
                    messageText = 'Me: $messageText';
                  }

                  return {
                    'user': user,
                    'chat_id': chatParticipant?.chat_id.toString() ?? '0',
                    'last_message': messageText,
                    'last_message_date': lastMessage?.date_time?.toString().split(' ')[0] ?? '', // Format as needed
                  };
                }).toList();


                // Show a message if there are no users with chats
                if (userWithChatData.isEmpty ||
                    userWithChatData
                        .every((userData) => userData['chat_id'] == '0')) {
                  return Center(
                      child: Text("Start Chatting with Friends Now!"));
                }

                return Column(
                  children: userWithChatData
                      .where((userData) =>
                          userData['chat_id'] !=
                          '0') // Exclude users with no chat_id
                      .map((userData) {
                    final user = userData['user'] as User;
                    final chatId = userData['chat_id'] as String;
                    final lastMessage = userData['last_message'] as String;
                    final lastMessageDate =
                        userData['last_message_date'] as String;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatMessage(
                                own_user_id: widget.user_id,
                                other_user_id: user.user_id.toString(),
                                chat_id: chatId, // Pass the chat_id
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xffEEEEEE),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: user.profile_picture != null
                                    ? AssetImage(
                                        "images/profile/${user.profile_picture}")
                                    : const AssetImage("icons/profile.png")
                                        as ImageProvider,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.nickname ?? "Unknown",
                                      style: TextStyle(
                                        color: Color(0xff4C315C),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                      width: 160,
                                      child: Text(
                                        lastMessage,
                                        style: TextStyle(
                                          color: Color(0xff5D5D5D),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                lastMessageDate,
                                style: TextStyle(
                                  color: Color(0xff5D5D5D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
