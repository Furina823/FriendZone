import 'package:flutter/material.dart';
import 'package:friendzone_application/chat/friend_request.dart';
import '../profile/other_profile.dart';
import '../model/friend.dart';
import '../model/user.dart';

class FriendHistory extends StatefulWidget {
  final String user_id;

  const FriendHistory({super.key, required this.user_id});

  @override
  State<FriendHistory> createState() => _FriendHistoryState();
}

class _FriendHistoryState extends State<FriendHistory> {
  late Future<List<User>> futureUsers;
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers().then((users) async {
      final friends = await fetchFriends();
      final friendUserIds = friends
        .where((friend) =>
            friend.user_id.toString() ==
            widget.user_id) // Match widget.user_id
        .map((friend) => friend.user_id_2.toString()) // Get friend.user_id_2
        .toSet();
      final filteredUsers = users.where((user) {
        return friendUserIds.contains(user.user_id.toString());
      }).toList();

      setState(() {
        this.filteredUsers = filteredUsers;
      });

      print(filteredUsers);

      return filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendRequest(
                  user_id: widget.user_id,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.centerRight,
            child: Text(
              "Friend Requests",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (userSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${userSnapshot.error}'),
                  );
                } else if (!userSnapshot.hasData ||
                    userSnapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Add Some Friends Now!'),
                  );
                } else {
                  List<User> users = userSnapshot.data!;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      User user = users[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherProfile(
                                        own_user_id: widget.user_id,
                                        user_id: user.user_id.toString())));
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
                                  backgroundImage: AssetImage(
                                      "images/profile/${user.profile_picture}"),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        user.nickname!,
                                        style: TextStyle(
                                          color: Color(0xff4C315C),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      // Add any additional information you want here
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}
