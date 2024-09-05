import 'package:flutter/material.dart';
import '../model/request.dart';
import '../model/user.dart';
import '../model/friend.dart';

class FriendRequest extends StatefulWidget {
  final String user_id;

  const FriendRequest({super.key, required this.user_id});

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  late Future<List<User>> futureUsers;
  late Future<List<Request>> futureRequests;
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
    futureRequests = fetchRequests();
  }

  Future<List<User>> _fetchFilteredUsers() async {
    final users = await futureUsers;
    final requests = await futureRequests;

    final requestUserIds = requests
        .where((request) => request.user_id_2.toString() == widget.user_id)
        .map((request) => request.user_id.toString())
        .toSet();

    return users.where((user) {
      return requestUserIds.contains(user.user_id.toString());
    }).toList();
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
              "Friend Requests",
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<User>>(
        future: _fetchFilteredUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Add Some Friends Now!'),
            );
          } else {
            List<User> users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffEEEEEE),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage("images/profile/${user.profile_picture}"),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                try {
                                  // Create friends
                                  await createFriend(widget.user_id, user.user_id.toString());
                                  await createFriend(user.user_id.toString(), widget.user_id);
                                  
                                  // Fetch requests again to find the specific request to delete
                                  final requests = await fetchRequests();
                                  final request = requests.firstWhere(
                                    (r) => r.user_id_2.toString() == widget.user_id && r.user_id.toString() == user.user_id.toString(),
                                    orElse: () => Request()
                                  );

                                  if (request != null) {
                                    await deleteRequest(request.request_id.toString());
                                  }
                                  
                                  // Refresh the user list
                                  setState(() {
                                    futureUsers = fetchUsers();
                                    futureRequests = fetchRequests();
                                  });

                                } catch (e) {
                                  // Handle error
                                  print('Error processing request: $e');
                                }
                              },
                              child: Image.asset(
                                "icons/tick.png",
                                width: 20,
                              ),
                            ),
                            SizedBox(width: 30),
                            InkWell(
                              onTap: () async {
                                try {
                                  // Fetch the specific request ID to delete
                                  final requests = await fetchRequests();
                                  final request = requests.firstWhere((r) => r.user_id_2.toString() == widget.user_id && r.user_id.toString() == user.user_id.toString(),
                                    orElse: () => Request()
                                  );

                                  if (request != null) {
                                    await deleteRequest(request.request_id.toString());
                                  }

                                  setState(() {
                                    futureUsers = fetchUsers();
                                    futureRequests = fetchRequests();
                                  });
                                } catch (e) {
                                  // Handle error
                                  print('Error deleting request: $e');
                                }
                              },
                              child: Image.asset(
                                "icons/close.png",
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
