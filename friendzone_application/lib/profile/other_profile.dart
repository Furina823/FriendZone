import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_application/chat/chat_message.dart';
import 'package:friendzone_application/model/chatparticipant.dart';
import 'more.dart';
import 'package:video_player/video_player.dart';
import '../model/event.dart';
import '../model/friend.dart';
import '../model/post.dart';
import '../model/preferences.dart';
import '../model/request.dart';
import '../model/user.dart';
import 'profile_data_processing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtherProfile extends StatefulWidget {
  final String own_user_id;
  final String user_id;

  const OtherProfile(
      {super.key, required this.own_user_id, required this.user_id});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  late Future<User> futureUser;
  late Future<Map<String, List<String>>> futurePreferences;
  late Future<Preferences> futurePreference;
  late Future<User> futureOwn;
  late Future<List<Post>> futureposts;
  late Future<List<Friend>> futurefriends;
  late Future<List<Event>> futureEvents;

  int calculateAge(String dob) {
    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  String setgender(String gender) {
    if (gender == "male") {
      return "icons/male.png";
    } else {
      return "icons/female.png";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    futureUser = fetchUser(widget.user_id);
    futurePreferences = getPreference(widget.user_id);
    futurePreference = fetchPreference(widget.user_id);
    futureposts = fetchPosts();
    futurefriends = fetchFriends();
    futureEvents = fetchEvents();
  }

  Future<int> getPost() async {
    try {
      List<Post> posts = await futureposts; // Fetch the list of posts
      int count = 0;

      for (Post post in posts) {
        if (post.user_id.toString() == widget.user_id) {
          count++; // Increment count for each post by the user
        }
      }

      return count; // Return the count of posts by the user
    } catch (e) {
      print('Error fetching posts: $e'); // Handle any errors
      return 0; // Return 0 if there's an error
    }
  }

  void updateUserProfile() {
    setState(() {
      fetchData();
    });
  }

  Future<int> getFriends() async {
    try {
      List<Friend> friends = await futurefriends;

      // Filter friends who are connected with the user
      List<Friend> filteredFriends = friends
          .where((friend) =>
              friend.user_id.toString() == widget.user_id ||
              friend.user_id_2.toString() == widget.user_id)
          .toList();

      // Use a Set to track unique friendships
      Set<String> uniqueFriendships = {};

      for (Friend friend in filteredFriends) {
        String key1 = '${friend.user_id}_${friend.user_id_2}';
        String key2 = '${friend.user_id_2}_${friend.user_id}';

        // Add unique friendships to the Set
        if (!uniqueFriendships.contains(key1) &&
            !uniqueFriendships.contains(key2)) {
          uniqueFriendships.add(key1);
        }
      }

      // Return the count of unique friendships
      return uniqueFriendships.length;
    } catch (e) {
      print('Error fetching friends: $e');
      return 0;
    }
  }

  void _showReportDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportDialog(userId: userId);
      },
    );
  }

  void _showBanDialog(BuildContext context, String userId, String ownId) {
    String userId1 = userId;
    String ownId1 = ownId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BanDialog(
          userId: userId1,
          ownId: ownId1,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: FutureBuilder<User>(
            future: fetchUser(widget.user_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No user found.');
              } else {
                final user = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 3,
                      blurRadius: 10,
                    )
                  ]),
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
                    title: Container(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        user.nickname!,
                        style: TextStyle(
                          fontFamily: 'Itim',
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            showMenu(
                              color: Color(0xffF3F3F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              context: context,
                              position: RelativeRect.fromLTRB(100, 140, 10, 0),
                              items: [
                                PopupMenuItem(
                                  onTap: () {
                                    _showReportDialog(context, widget.user_id);
                                  },
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.report,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Report",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    _showBanDialog(context, widget.own_user_id,
                                        widget.user_id);
                                  },
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.block,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Block",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: Icon(Icons.more_vert)),
                    ],
                  ),
                );
              }
            }),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    User user = snapshot.data!;
                    return FutureBuilder<Map<String, List<String>>>(
                        future: futurePreferences,
                        builder: (context, preferenceSnapshot) {
                          if (preferenceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: const CircularProgressIndicator());
                          } else if (preferenceSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Error: ${preferenceSnapshot.error}'));
                          } else if (preferenceSnapshot.hasData) {
                            Map<String, List<String>> preferences =
                                preferenceSnapshot.data!;
                            return FutureBuilder<Preferences>(
                                future: futurePreference,
                                builder: (context, psnapshot) {
                                  if (psnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child:
                                            const CircularProgressIndicator());
                                  } else if (psnapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${psnapshot.error}'));
                                  } else if (psnapshot.hasData) {
                                    Preferences preferencess = psnapshot.data!;
                                    return Column(
                                      children: [
                                        Container(
                                          height: 130,
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 20, end: 20, top: 20),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Image.asset(
                                                    "images/profile/${user.profile_picture}",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                24, 5, 8, 0),
                                                        width: 110,
                                                        height: 60,
                                                        child:
                                                            FutureBuilder<int>(
                                                          future: getPost(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const CircularProgressIndicator(); // Show loading indicator while waiting
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot.error}'); // Show error message if there is an error
                                                            } else if (snapshot
                                                                .hasData) {
                                                              int postCount =
                                                                  snapshot.data ??
                                                                      0;
                                                              return Column(
                                                                children: [
                                                                  const Text(
                                                                    "Post",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Itim',
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "$postCount",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xff4C315C),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  '0');
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        //color: Colors.red,
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                24, 5, 8, 0),
                                                        width: 110,
                                                        height: 60,
                                                        child:
                                                            FutureBuilder<int>(
                                                          future: getFriends(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const CircularProgressIndicator();
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  "${snapshot.error}");
                                                            } else if (snapshot
                                                                    .hasData ||
                                                                snapshot.data !=
                                                                    null) {
                                                              int friendcount =
                                                                  snapshot.data ??
                                                                      0;
                                                              return Column(
                                                                children: [
                                                                  const Text(
                                                                    "Friend",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Itim',
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${friendcount}",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xff4C315C),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  "0");
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: SizedBox(
                                                            width: 200,
                                                            height: 50,
                                                            child: Column(
                                                              children: [
                                                                OtherProfileButton(
                                                                    ownId: widget
                                                                        .own_user_id,
                                                                    otherId: widget
                                                                        .user_id
                                                                        .toString()),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 20, end: 20),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${user.nickname}",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      calculateAge(user
                                                              .date_of_birth
                                                              .toString())
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 1,
                                                    ),
                                                    Image.asset(
                                                      setgender(user.gender!),
                                                      width: 17,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      width: 55,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff4C315C),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${preferencess.mbti!.toUpperCase()}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      child: Center(
                                                        child: Image.asset(
                                                          "icons/quote.png",
                                                          width: 15,
                                                          color: const Color(
                                                              0xff4C315C),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 300,
                                                      child: Text(
                                                        "${user.quote != 'null' ? user.quote : ' - '}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          size: 20,
                                                          color:
                                                              Color(0xff4C315C),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 90,
                                                      child: Text(
                                                        "${user.location != 'null' ? user.location : ' - '}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Icon(
                                                      Icons.work,
                                                      color: Color(0xff4C315C),
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(
                                                        "${user.current_state != 'null' ? user.current_state : ' - '}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Icon(
                                                      Icons.language,
                                                      color: Color(0xff4C315C),
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 60,
                                                      child: Text(
                                                        "${user.language != 'null' ? user.language : ' - '}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.school,
                                                          size: 20,
                                                          color:
                                                              Color(0xff4C315C),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 300,
                                                      child: Text(
                                                        "${user.current_state!.toLowerCase() != 'student' ? '${user.school != 'null' ? 'Graduated at ${user.school}' : ' - '}' : (user.school != 'null' ? user.school : ' - ')}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      child: Center(
                                                        child: Image.asset(
                                                          "icons/award.png",
                                                          width: 20,
                                                          color:
                                                              Color(0xff4C315C),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 300,
                                                      child: Text(
                                                        "${user.award != 'null' ? user.award : ' - '}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                child: FutureBuilder(
                                                    future: futureEvents,
                                                    builder: (context,
                                                        eventSnapshot) {
                                                      if (eventSnapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      } else if (eventSnapshot
                                                          .hasError) {
                                                        return Text(
                                                            '${eventSnapshot.error}');
                                                      } else if (!eventSnapshot
                                                              .hasData ||
                                                          eventSnapshot
                                                              .data!.isEmpty) {
                                                        return Center(
                                                          child: Text(
                                                              "No events found"),
                                                        );
                                                      } else {
                                                        List<Event> events =
                                                            eventSnapshot.data!;

                                                        return Reward(
                                                          events: events,
                                                          rewardIT:
                                                              user.event_it,
                                                          rewardFinance: user
                                                              .event_finance,
                                                          rewardSocial:
                                                              user.event_social,
                                                          rewardMedicine: user
                                                              .event_medicine,
                                                        );
                                                      }
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Divider(
                                                height: 5,
                                                thickness: 3,
                                                indent: 5,
                                                endIndent: 5,
                                                color: Color(0xff9D9D9D),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 170,
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 25, end: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: buildPreferenceList(
                                                    preferences),
                                              ),
                                              Spacer(),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: buildPreferenceList2(
                                                    preferences),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          "POST",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          child: FutureBuilder<Set<String>>(
                                            future:
                                                profileImages(widget.user_id),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<Set<String>>
                                                    postSnapshot) {
                                              if (postSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (postSnapshot
                                                  .hasError) {
                                                return Center(
                                                    child: Text(
                                                        'Error: ${postSnapshot.error}'));
                                              } else if (!postSnapshot
                                                      .hasData ||
                                                  postSnapshot.data!.isEmpty) {
                                                return Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "No Post Yet!",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                final imagePaths =
                                                    postSnapshot.data!;
                                                return GridView.count(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0, bottom: 1),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  crossAxisCount: 3,
                                                  children:
                                                      imagePaths.map((path) {
                                                    return MediaDisplay(
                                                        assetPath: path);
                                                  }).toList(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                });
                          } else {
                            return const CircularProgressIndicator();
                          }
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtherProfileButton extends StatefulWidget {
  final String ownId;
  final String otherId;

  const OtherProfileButton(
      {required this.ownId, required this.otherId, Key? key})
      : super(key: key);

  @override
  _OtherProfileButtonState createState() => _OtherProfileButtonState();
}

class _OtherProfileButtonState extends State<OtherProfileButton> {
  late Future<List<bool>> statusFuture;
  late Future<User> futureUser;
  bool requestSent = false;
  Map<String, String> similarityScores = {};

  @override
  void initState() {
    super.initState();
    statusFuture = Future.wait([
      isFriend(),
      checkRequestExists(widget.ownId, widget.otherId),
    ]);
    futureUser = fetchUser(widget.otherId).then((user) {
      fetchAllSimilarities(widget.ownId, widget.otherId);
      return user;
    });
  }

  Future<bool> isFriend() async {
    try {
      List<Friend> friends = await fetchFriends();
      User user1 = await fetchUser(widget.ownId);
      User user2 = await fetchUser(widget.otherId);

      return friends.any((friend) =>
          (friend.user_id == user1.user_id &&
              friend.user_id_2 == user2.user_id) ||
          (friend.user_id == user2.user_id &&
              friend.user_id_2 == user1.user_id));
    } catch (e) {
      print("Error checking friend status: $e");
      return false;
    }
  }

  Future<bool> checkRequestExists(String ownId, String otherId) async {
    try {
      final requests = await fetchRequests();
      return requests.any((request) =>
          request.user_id.toString() == ownId &&
          request.user_id_2.toString() == otherId);
    } catch (e) {
      print("Error checking request existence: $e");
      return false;
    }
  }

  Future<void> sendFriendRequest() async {
    try {
      await createRequest(widget.ownId, widget.otherId);
      setState(() {
        requestSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send friend request')),
      );
    }
  }

  Future<void> fetchAllSimilarities(String userId, String user) async {
    final url = 'http://10.0.2.2:5000/similarities?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final Map<String, String> scores = {};
        for (var item in data) {
          scores[item['user_id']] = "${item['similarity']}%";
        }

        setState(() {
          similarityScores = scores;
        });
      } else {
        print('widget.otherId: ${widget.otherId}');
        print(
            'Similarity score for ${widget.otherId.toString()}: ${similarityScores[widget.otherId.toString()] ?? "Not Available"}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
      future: statusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Error occurred');
        } else if (snapshot.hasData) {
          final List<bool> results = snapshot.data!;
          final bool isFriend = results[0];
          final bool requestExists = results[1];
          final similarityScore = similarityScores[widget.otherId] ?? "0%";

          if (requestSent || requestExists) {
            // Request has been sent, show "Request Sent" button
            return Column(
              children: [
                Text(
                  "Compatibility Score $similarityScore",
                  style: const TextStyle(fontSize: 11),
                ),
                SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: 130,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: null, // Disable the button
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(217, 217, 217, 1))),
                    child: const Text(
                      "Request Sent",
                      style: TextStyle(color: Color(0xff4C315C), fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          } else if (isFriend) {
            // They are friends, show the "Message" button
            return Column(
              children: [
                Text(
                  "Compatibility Score $similarityScore",
                  style: const TextStyle(fontSize: 11),
                ),
                SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: 130,
                  height: 30,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(217, 217, 217, 1))),
                    onPressed: () async {
                      try {
                        // Find friend ids in friend table
                        List<Friend> friends = await fetchFriends();
                        List<Friend> friendsList = [];

                        // Filter friends based on user_id and user_id_2
                        for (var f in friends) {
                          if ((f.user_id.toString() == widget.ownId &&
                                  f.user_id_2.toString() == widget.otherId) ||
                              (f.user_id.toString() == widget.otherId &&
                                  f.user_id_2.toString() == widget.ownId)) {
                            friendsList.add(f);
                          }
                        }

                        if (friendsList.isNotEmpty) {
                          // Find chat id in chat participant table
                          List<ChatParticipant> chatParticipants =
                              await fetchChatParticipants();
                          ChatParticipant? chatParticipant;

                          for (var cp in chatParticipants) {
                            if ((cp.friend_id == friendsList[0].friend_id &&
                                    cp.friend_id_2 ==
                                        friendsList[1].friend_id) ||
                                (cp.friend_id == friendsList[1].friend_id &&
                                    cp.friend_id_2 ==
                                        friendsList[0].friend_id)) {
                              chatParticipant = cp;
                              break;
                            }
                          }

                          if (chatParticipant != null) {
                            // Navigate to chat_message.dart with existing chat id
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatMessage(
                                  own_user_id: widget.ownId,
                                  other_user_id: widget.otherId,
                                  chat_id:
                                      chatParticipant?.chat_id.toString() ??
                                          "0",
                                ),
                              ),
                            );

                            print("Succeed");
                          } else {
                            // Create a new chat participant with distinct friend ids
                            if (friendsList.length == 2) {
                              final friend1 = friendsList[0];
                              final friend2 = friendsList[1];

                              // Ensure friend_id and friend_id_2 are distinct
                              if (friend1.friend_id != friend2.friend_id) {
                                try {
                                  // Create a chat participant with the correct friend IDs
                                  await createChatParticipant(
                                    friend_id: friend1.friend_id
                                        .toString(), // Friend ID for the first user
                                    friend_id_2: friend2.friend_id
                                        .toString(), // Friend ID for the second user
                                  );
                                } catch (e) {
                                  // Handle any errors that occur during the creation of the chat participant
                                  print('Error creating chat participant: $e');
                                }

                                  List<ChatParticipant> newChatParticipants =
                                      await fetchChatParticipants();
                                  ChatParticipant? newChatParticipant;

                                  for (var cp in newChatParticipants) {
                                    if ((cp.friend_id ==
                                                friendsList[0].friend_id &&
                                            cp.friend_id_2 ==
                                                friendsList[1].friend_id) ||
                                        (cp.friend_id ==
                                                friendsList[1].friend_id &&
                                            cp.friend_id_2 ==
                                                friendsList[0].friend_id)) {
                                      newChatParticipant = cp;
                                      break;
                                    }
                                  }
                                  // Navigate to chat_message.dart with new chat id
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatMessage(
                                        own_user_id: widget.ownId,
                                        other_user_id: widget.otherId,
                                        chat_id: newChatParticipant?.chat_id
                                            .toString() ?? "0",
                                      ),
                                    ),
                                  );
                                
                              } else {
                                print('Friend IDs must be distinct.');
                              }
                            } else {
                              // Handle the case where there are not exactly 2 friends in the list
                              print(
                                  'Unexpected number of friends: ${friendsList.length}');
                            }
                          }
                        } else {
                          // Handle case where no friend ids are found
                          print('No friend ids found');
                        }
                      } catch (e) {
                        print('Error: $e');
                        print("Failed to create chat");
                      }
                    },
                    child: const Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidComment,
                          color: Color.fromRGBO(77, 26, 107, 1),
                          size: 13,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "  Message",
                          style: TextStyle(
                            color: Color.fromRGBO(77, 26, 107, 1),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // They are not friends, show the "Add Friend" button
            return Column(
              children: [
                Text(
                  "Compatibility Score $similarityScore",
                  style: const TextStyle(fontSize: 11),
                ),
                SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: 130,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: sendFriendRequest,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(217, 217, 217, 1))),
                    child: const Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.userPlus,
                          color: Color.fromRGBO(77, 26, 107, 1),
                          size: 13,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Add Friend",
                          style: TextStyle(
                            color: Color.fromRGBO(77, 26, 107, 1),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return const Text('Error occurred');
        }
      },
    );
  }
}

class Reward extends StatefulWidget {
  final List<Event> events; // List of all events
  final int? rewardIT;
  final int? rewardFinance;
  final int? rewardSocial;
  final int? rewardMedicine;

  const Reward({
    super.key,
    required this.events,
    required this.rewardIT,
    required this.rewardFinance,
    required this.rewardSocial,
    required this.rewardMedicine,
  });

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  String getEventName(int? eventId) {
    if (eventId == null) return '';
    try {
      Event event = widget.events.firstWhere(
        (event) => event.event_id == eventId,
      );
      return event.title;
    } catch (e) {
      return "null";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (widget.rewardIT != null &&
              widget.rewardIT != "null" &&
              widget.rewardIT != "None" &&
              widget.rewardIT != "")
            Container(
              child: Row(
                children: [
                  Container(
                      width: 25,
                      child: Center(
                        child: Image.asset(
                          "icons/it_badge.png",
                          width: 25,
                        ),
                      )),
                  SizedBox(width: 5),
                  Text(
                    getEventName(widget.rewardIT),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink(),
          if (widget.rewardMedicine != null &&
              widget.rewardMedicine != "null" &&
              widget.rewardMedicine != "None" &&
              widget.rewardMedicine != "")
            Container(
              child: Row(
                children: [
                  Container(
                      width: 25,
                      child: Center(
                        child: Image.asset(
                          "icons/medicine_badge.png",
                          width: 25,
                        ),
                      )),
                  SizedBox(width: 5),
                  Text(
                    getEventName(widget.rewardMedicine),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink(),
          if (widget.rewardFinance != null &&
              widget.rewardFinance != "null" &&
              widget.rewardFinance != "None" &&
              widget.rewardFinance != "")
            Container(
              child: Row(
                children: [
                  Container(
                      width: 25,
                      child: Center(
                        child: Image.asset(
                          "icons/finance_badge.png",
                          width: 25,
                        ),
                      )),
                  SizedBox(width: 5),
                  Text(
                    getEventName(widget.rewardFinance),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink(),
          if (widget.rewardSocial != null &&
              widget.rewardSocial != "null" &&
              widget.rewardSocial != "None" &&
              widget.rewardSocial != "")
            Container(
              child: Row(
                children: [
                  Container(
                      width: 25,
                      child: Center(
                        child: Image.asset(
                          'icons/social_badge.png',
                          width: 25,
                        ),
                      )),
                  SizedBox(width: 5),
                  Text(
                    getEventName(widget.rewardSocial),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}

Widget buildPreferenceList(Map<String, List<String>> preferences) {
  List<Widget> children = [];

  for (String key in preferences.keys) {
    if (key == "Food") {
      break;
    }

    children.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(300)),
              color: Color.fromRGBO(77, 26, 107, 1),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (String value in preferences[key]!)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 10, wordSpacing: 3),
                      strutStyle: const StrutStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return Container(
    height: double.maxFinite,
    width: 160,
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align the column to the start
      children: children,
    ),
  );
}

Widget buildPreferenceList2(Map<String, List<String>> preferences) {
  List<Widget> children = [];
  bool startPrinting = false;

  for (String key in preferences.keys) {
    if (key == "Food") {
      startPrinting = true;
    }

    if (startPrinting) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(300)),
                color: Color.fromRGBO(77, 26, 107, 1),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                key,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String value in preferences[key]!)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 10, wordSpacing: 3),
                        strutStyle:
                            const StrutStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  return Container(
    height: double.maxFinite,
    width: 160,
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align the column to the start
      children: children,
    ),
  );
}

class MediaDisplay extends StatefulWidget {
  final String? assetPath;

  const MediaDisplay({Key? key, required this.assetPath}) : super(key: key);

  @override
  _MediaDisplayState createState() => _MediaDisplayState();
}

class _MediaDisplayState extends State<MediaDisplay> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    if (widget.assetPath != null && widget.assetPath!.endsWith('.mp4')) {
      _videoPlayerController = VideoPlayerController.asset(
          "images/posts/${widget.assetPath}")
        ..initialize().then((_) {
          setState(() {}); // Refresh the widget when the video is initialized
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetPath == null || widget.assetPath!.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text(
              "No Post Yet!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 23,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Create a Post Now!",
                style: TextStyle(
                  color: Color(0xff4C315C),
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.assetPath!.endsWith('.mp4')) {
      if (_videoPlayerController == null ||
          !_videoPlayerController!.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }
      return AspectRatio(
        aspectRatio: 1,
        child: VideoPlayer(_videoPlayerController!),
      );
    } else if (widget.assetPath == 'null') {
      return const Text(" - ");
    } else if (widget.assetPath!.endsWith('.jpg') ||
        widget.assetPath!.endsWith('.png') ||
        widget.assetPath!.endsWith('.jpeg')) {
      return Image.asset(
        "images/posts/${widget.assetPath}",
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: Color(0xffD9D9D9),
            border: Border.all(color: Colors.black12)),
        child: Center(
          child: Text(
            widget.assetPath!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff4C315C),
            ),
          ),
        ),
      );
    }
  }
}
