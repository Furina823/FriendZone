import 'package:flutter/material.dart';
import 'package:friendzone_application/model/chatparticipant.dart';
import '../model/user.dart';
import '../model/friend.dart';

class ChatDetail extends StatefulWidget {
  final String user_id;
  final String chat_id;

  const ChatDetail({super.key, required this.user_id, required this.chat_id,});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late Future<User> futureUser;
  late Future<List<ChatParticipant>> futureChats;
  late Future<List<Friend>> futureFriends;


  
  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(widget.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_left_sharp,
                size: 50,
              ),
              color: Color(0xff4C315C),
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Chat Settings",
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('No user found'),
              );
            } else {
              User user = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          AssetImage("images/profile/${user.profile_picture}"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.nickname!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4C315C),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Online",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff5D5D5D),
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 250, // Set the width of the button
                      child: ElevatedButton(
                        onPressed: () {
                          deleteChatParticipant(widget.chat_id);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Delete Chat",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
