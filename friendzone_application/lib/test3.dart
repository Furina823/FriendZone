import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'social/create_social.dart';
import 'model/post.dart';
import 'model/user.dart';
import 'model/comment.dart';
import 'model/review.dart';
import 'model/friend.dart';

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
      home: SocialPage(),
    );
  }
}

class SocialPage extends StatefulWidget {
  final String user_id = '40';

  //const SocialPage({super.key, required this.user_id});

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  late Future<List<User>> futureUsers;
  late Future<List<Post>> futurePosts;
  late Future<List<Comment>> futureComments;
  final TextEditingController _commentController = TextEditingController();
  List<User> filteredUsers = [];

  Future<void> _submitComment(int postId, int userId) async {
    String commentText = _commentController.text;
    if (commentText.isEmpty) return;

    DateTime now = DateTime.now();

    try {
      await createComment(
        post_id: postId.toString(),
        user_id: userId.toString(),
        comment_text: commentText,
        date_time: now,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment created successfully!'),
        ),
      );
      setState(() {
        // If you're updating local state, add the new comment to the list
        futureComments = fetchComments();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment is not created!'),
        ),
      );
    }

    _commentController.clear();
    Navigator.pop(context);
  }

  Future<void> onRefresh() async {
    setState(() {
      futureUsers = fetchUsers();
      futurePosts = fetchPosts();
      futureComments = fetchComments();
    });
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers().then((users) async {
      final friends = await fetchFriends();
      final friendUserIds =
          friends.map((friend) => friend.user_id_2.toString()).toSet();
      final filteredUsers = users.where((user) {
        return friendUserIds.contains(user.user_id.toString());
      }).toList();

      setState(() {
        this.filteredUsers = filteredUsers;
      });

      print(filteredUsers);

      return filteredUsers;
    });
    futurePosts = fetchPosts();
    futureComments = fetchComments();
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
                onPressed: () {},
                icon: Icon(Icons.search_rounded),
                iconSize: 30,
                color: Color(0xff4C315C),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateSocial(user_id: widget.user_id)),
                  );
                },
                icon: Icon(Icons.add_circle_outline_rounded),
                iconSize: 30,
                color: Color(0xff4C315C),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
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
            } else if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
              return Center(
                child: Text('No users found.'),
              );
            } else {
              return FutureBuilder<List<Post>>(
                future: futurePosts,
                builder: (context, postSnapshot) {
                  if (postSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (postSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${postSnapshot.error}'),
                    );
                  } else if (!postSnapshot.hasData ||
                      postSnapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No posts found.'),
                    );
                  } else {
                    return FutureBuilder<List<Comment>>(
                      future: futureComments,
                      builder: (context, commentSnapshot) {
                        if (commentSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (commentSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${commentSnapshot.error}'),
                          );
                        } else if (!commentSnapshot.hasData ||
                            commentSnapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No comments found.'),
                          );
                        } else {
                          return FutureBuilder<User>(
                            future: fetchUser(widget.user_id),
                            builder: (BuildContext context,
                                AsyncSnapshot<User> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return Text('No user found.');
                              } else {
                                final loggedInUser = snapshot.data!;
                                DateTime now = DateTime.now();

                                return ListView.builder(
                                  itemCount: postSnapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    List<Post> sortedPosts = postSnapshot.data!
                                        .where((post) =>
                                            (post.date_time?.isBefore(now) ??
                                                false) &&
                                            filteredUsers.any((user) =>
                                                user.user_id.toString() ==
                                                post.user_id.toString()))
                                        .toList()
                                      ..sort((a, b) {
                                        DateTime aDate = a.date_time ??
                                            DateTime.fromMillisecondsSinceEpoch(
                                                0);
                                        DateTime bDate = b.date_time ??
                                            DateTime.fromMillisecondsSinceEpoch(
                                                0);
                                        return bDate.compareTo(
                                            aDate); // Descending order
                                      });

                                    try {
                                      if (index < 0 ||
                                          index >= sortedPosts.length) {
                                        throw RangeError('Index out of range');
                                      }

                                      Post post = sortedPosts[index];

                                      User? user =
                                          userSnapshot.data!.firstWhere(
                                        (user) => user.user_id == post.user_id,
                                        orElse: () => User(),
                                      );

                                      String? mediaPath = post.post_media;
                                      bool isImage = mediaPath != null &&
                                          (mediaPath.endsWith('.jpg') ||
                                              mediaPath.endsWith('.png') ||
                                              mediaPath.endsWith('.jpeg'));
                                      bool isVideo = mediaPath != null &&
                                          mediaPath.endsWith('.mp4');

                                      FlickManager? flickManager;
                                      if (isVideo) {
                                        flickManager = FlickManager(
                                          videoPlayerController:
                                              VideoPlayerController.asset(
                                                  "images/posts/${mediaPath}"),
                                        );
                                      }

                                      return Container(
                                        color: Colors.white,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 17),
                                              Container(
                                                color: Color(0x80D9D9D9),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Header
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {},
                                                            child: CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      "images/profile/${user.profile_picture}"),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${user.nickname}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xff4C315C),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${user.current_state != 'null' ? user.current_state : ''}${(user.current_state != 'null' && post.location != 'null') ? ' | ' : ''}${post.location != 'null' ? post.location : ''}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff5D5D5D),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          IconButton(
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Container(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 10),
                                                                              height: 5,
                                                                              width: 100,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xff747474),
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              width: 360,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(10),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => SimpleDialog(
                                                                                            title: const Text(
                                                                                              "Confirm Report",
                                                                                              style: TextStyle(
                                                                                                fontWeight: FontWeight.w800,
                                                                                                color: Color(0xff4C315C),
                                                                                              ),
                                                                                            ),
                                                                                            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                                            backgroundColor: Color(0xffD9D9D9),
                                                                                            children: [
                                                                                              const Text(
                                                                                                "You are about to report this post for violating our community guidelines. Please confirm your action.",
                                                                                                style: TextStyle(fontWeight: FontWeight.w600),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              Row(
                                                                                                children: [
                                                                                                  Spacer(),
                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: const Text(
                                                                                                      'Cancel',
                                                                                                      style: TextStyle(color: Color(0xff4C315C), fontSize: 16),
                                                                                                    ),
                                                                                                  ),
                                                                                                  TextButton(
                                                                                                    onPressed: () async {
                                                                                                      try {
                                                                                                        await createReview(null, post.post_id.toString());
                                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                                          SnackBar(content: Text('Report submitted successfully.')),
                                                                                                        );
                                                                                                      } catch (e) {
                                                                                                        print('Error creating review: $e'); // Log the error for debugging
                                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                                          SnackBar(content: Text('Report not submitted: $e')),
                                                                                                        );
                                                                                                      }
                                                                                                      Navigator.pop(context);
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: const Text(
                                                                                                      'Report',
                                                                                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.report,
                                                                                            size: 30,
                                                                                            color: Colors.red,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 20,
                                                                                          ),
                                                                                          Text(
                                                                                            "Report",
                                                                                            style: TextStyle(fontSize: 17, color: Colors.red),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(Icons
                                                                .more_vert),
                                                            color: Color(
                                                                0xff4C315C),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Posts
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        if (mediaPath != null &&
                                                            mediaPath != 'null')
                                                          if (isImage)
                                                            AspectRatio(
                                                              aspectRatio: 1,
                                                              child:
                                                                  Image.asset(
                                                                "images/posts/${mediaPath}",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          else if (isVideo &&
                                                              flickManager !=
                                                                  null)
                                                            AspectRatio(
                                                              aspectRatio: 1,
                                                              child: FlickVideoPlayer(
                                                                  flickManager:
                                                                      flickManager),
                                                            )
                                                          else
                                                            SizedBox.shrink(),
                                                      ],
                                                    ),
                                                    //Footer
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              LikeButton(
                                                                likeBuilder: (bool
                                                                    isLiked) {
                                                                  return Icon(
                                                                    isLiked
                                                                        ? Icons
                                                                            .favorite
                                                                        : Icons
                                                                            .favorite_border_outlined,
                                                                    color: isLiked
                                                                        ? Colors
                                                                            .red
                                                                        : Color(
                                                                            0xff4C315C),
                                                                  );
                                                                },
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      List<Comment> postComments = commentSnapshot
                                                                          .data!
                                                                          .where((comment) =>
                                                                              comment.post_id ==
                                                                              post.post_id)
                                                                          .toList();

                                                                      return Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                                                                        height:
                                                                            500, // Specify a height for the modal
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 10),
                                                                              height: 5,
                                                                              width: 100,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xff747474),
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            const Text(
                                                                              "Comment",
                                                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            Expanded(
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  children: postComments.isNotEmpty
                                                                                      ? postComments.map((c) {
                                                                                          // Assuming user for each comment is fetched correctly
                                                                                          User? user = userSnapshot.data!.firstWhere(
                                                                                            (user) => user.user_id == c.user_id,
                                                                                            orElse: () => User(), // Provide a default User if not found
                                                                                          );

                                                                                          return Container(
                                                                                            width: double.infinity,
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                CircleAvatar(
                                                                                                  radius: 20,
                                                                                                  backgroundImage: AssetImage("images/profile/${user.profile_picture}"),
                                                                                                ),
                                                                                                SizedBox(width: 10),
                                                                                                Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      '${user.nickname}',
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 13,
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      c.comment_text,
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 12,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Spacer(),
                                                                                                Text(
                                                                                                  formatDateTime(c.date_time),
                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xff747474),
                                                                                                    fontSize: 10,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        }).toList()
                                                                                      : [
                                                                                          Center(
                                                                                            child: Text(
                                                                                              "Be the first to comment!",
                                                                                              style: TextStyle(
                                                                                                fontSize: 15,
                                                                                                color: Colors.grey,
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                              child: Container(
                                                                                height: 75,
                                                                                color: Colors.white,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(15),
                                                                                  child: Container(
                                                                                    width: 320,
                                                                                    alignment: Alignment.center,
                                                                                    child: TextField(
                                                                                      controller: _commentController,
                                                                                      decoration: InputDecoration(
                                                                                        hintText: 'Add a Comment!',
                                                                                        hintStyle: TextStyle(fontSize: 13, color: Color(0xff747474)),
                                                                                        border: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Color(0xff4C315C), width: 2.0),
                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                        ),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Color(0xff4C315C), width: 2.0),
                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                        ),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Color(0xff4C315C), width: 2.0),
                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                        ),
                                                                                        suffixIcon: IconButton(
                                                                                          icon: Image.asset(
                                                                                            "icons/send.png",
                                                                                            width: 20,
                                                                                            color: Color(0xff4C315C),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            _submitComment(post.post_id!, loggedInUser.user_id!);
                                                                                          },
                                                                                        ),
                                                                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .chat_bubble_rounded,
                                                                  size: 30,
                                                                ),
                                                                color: Color(
                                                                    0xff4C315C),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            post.post_text !=
                                                                    'null'
                                                                ? '${post.post_text}'
                                                                : '',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            formatDateTime(
                                                                post.date_time),
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff5D5D5D),
                                                              fontSize: 11,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      print("Error $e");
                                      return SizedBox.shrink();
                                    }
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
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
