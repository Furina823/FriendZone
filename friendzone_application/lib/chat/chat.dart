import 'package:flutter/material.dart';
import 'package:friendzone_application/chat/chat_history.dart';
import 'package:friendzone_application/chat/friend_history.dart';
import 'package:friendzone_application/social/search_profile.dart';


class ChatPage extends StatefulWidget {
  final String user_id;
  
  const ChatPage({super.key, required this.user_id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            backgroundColor: Colors.white,
            title: Image.asset(
              "images/logo.png",
              height: 60,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchProfile(user_id: widget.user_id)));
                },
                icon: Icon(Icons.search_rounded),
                iconSize: 30,
                color: Color(0xff4C315C),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(0);
                      },
                      child: Center(
                        child: Text(
                          "Chat",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == 0
                                ? Color(0xff4C315C)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    child: VerticalDivider(
                      color: Color(0xff9F9F9F),
                      width: 1,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                      child: Center(
                        child: Text(
                          "Friend",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == 1
                                ? Color(0xff4C315C)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Content for "Chat" tab
                ChatHistory(user_id: widget.user_id),
                // Content for "Friend" tab
                FriendHistory(user_id: widget.user_id,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
