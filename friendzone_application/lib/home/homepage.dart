import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../model/request.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/friend.dart';
import '../model/filter.dart';
import '../home/setting.dart';
import 'dart:math';
import '../profile/other_profile.dart';


class HomePage extends StatefulWidget {
  final String user_id;
  final FilterModel filterModel;

  const HomePage({super.key, required this.user_id, required this.filterModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> futureUsers;
  Map<String, String> similarityScores = {};
  final CardSwiperController controller = CardSwiperController();

  Future<bool> handleSwipeAction(
      CardSwiperDirection direction, User user) async {
    if (direction == CardSwiperDirection.left) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Dislike'),
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.fromLTRB(10, 5, 0, 5)),
      );
      return true;
    } else if (direction == CardSwiperDirection.right) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Liked'),
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.fromLTRB(10, 5, 0, 5)),
      );
      createRequest(widget.user_id, user.user_id.toString());
      return true;
    }
    return false;
  }

  int calculateAge(DateTime? dateofBirth) {
    if (dateofBirth == null) {
      return 0;
    }

    final today = DateTime.now();

    int age = today.year - dateofBirth.year;
    if (today.month < dateofBirth.month ||
        (today.month == dateofBirth.month && today.day < dateofBirth.day)) {
      age--;
    }
    return age;
  }

  Future<void> fetchAllSimilarities(String userId, List<User> users) async {
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
        print('Failed to load data. Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers().then((users) async {
      fetchAllSimilarities(widget.user_id, users);
      final friends = await fetchFriends();
      final friendUserIds = friends
          .where((friend) =>
              friend.user_id.toString() ==
              widget.user_id) // Match widget.user_id
          .map((friend) => friend.user_id_2.toString()) // Get friend.user_id_2
          .toSet();
      final requests = await fetchRequests();
      final requestUserIds = requests
          .where((request) =>
              request.user_id.toString() ==
              widget.user_id) // Match widget.user_id
          .map(
              (request) => request.user_id_2.toString()) // Get friend.user_id_2
          .toSet();

      // Filter users based on the criteria
      final filteredUsers = users
          .where((user) =>
              user.user_id.toString() != widget.user_id) // Exclude current user
          .where((user) {
        bool isAgeMatch = user.date_of_birth != null &&
            (calculateAge(user.date_of_birth) >=
                    widget.filterModel.ageRange.start &&
                calculateAge(user.date_of_birth) <=
                    widget.filterModel.ageRange.end);
        bool isGenderMatch = widget.filterModel.selectedGender == 'everyone' ||
            user.gender == widget.filterModel.selectedGender;
        final similarityScore =
            similarityScores[user.user_id.toString()] ?? "0%";
        final similarityValue =
            double.tryParse(similarityScore.replaceAll('%', '')) ?? 0;
        bool isCompatibilityMatch =
            similarityValue >= widget.filterModel.compatibilityRange.start &&
                similarityValue <= widget.filterModel.compatibilityRange.end;
        bool isLocationMatch = widget.filterModel.selectedState == 'All' ||
            user.location == widget.filterModel.selectedState;

        return !requestUserIds.contains(user.user_id.toString()) &&
            !friendUserIds.contains(user.user_id.toString()) &&
            isAgeMatch &&
            isGenderMatch &&
            isCompatibilityMatch &&
            isLocationMatch;
      }).toList();

      filteredUsers.shuffle(Random());
      return filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 10,
            )
          ]),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: null,
            backgroundColor: Colors.white,
            title: Image.asset(
              'images/logo.png',
              height: 60,
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final newFilterModel = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Setting(user_id: widget.user_id)),
                  );
                  if (newFilterModel is FilterModel) {
                    setState(() {
                      futureUsers = fetchUsers().then((users) async {
                      fetchAllSimilarities(widget.user_id, users);
                      final friends = await fetchFriends();
                      final friendUserIds = friends
                          .where((friend) =>
                              friend.user_id.toString() ==
                              widget.user_id) // Match widget.user_id
                          .map((friend) => friend.user_id_2.toString()) // Get friend.user_id_2
                          .toSet();
                      final requests = await fetchRequests();
                      final requestUserIds = requests
                          .where((request) =>
                              request.user_id.toString() ==
                              widget.user_id) // Match widget.user_id
                          .map(
                              (request) => request.user_id_2.toString()) // Get friend.user_id_2
                          .toSet();

                      // Filter users based on the criteria
                      final filteredUsers = users
                          .where((user) =>
                              user.user_id.toString() != widget.user_id) // Exclude current user
                          .where((user) {
                        bool isAgeMatch = user.date_of_birth != null &&
                            (calculateAge(user.date_of_birth) >=
                                    widget.filterModel.ageRange.start &&
                                calculateAge(user.date_of_birth) <=
                                    widget.filterModel.ageRange.end);
                        bool isGenderMatch = widget.filterModel.selectedGender == 'everyone' ||
                            user.gender == widget.filterModel.selectedGender;
                        final similarityScore =
                            similarityScores[user.user_id.toString()] ?? "0%";
                        final similarityValue =
                            double.tryParse(similarityScore.replaceAll('%', '')) ?? 0;
                        bool isCompatibilityMatch =
                            similarityValue >= widget.filterModel.compatibilityRange.start &&
                                similarityValue <= widget.filterModel.compatibilityRange.end;
                        bool isLocationMatch = widget.filterModel.selectedState == 'All' ||
                            user.location == widget.filterModel.selectedState;

                        return !requestUserIds.contains(user.user_id.toString()) &&
                            !friendUserIds.contains(user.user_id.toString()) &&
                            isAgeMatch &&
                            isGenderMatch &&
                            isCompatibilityMatch &&
                            isLocationMatch;
                      }).toList();

                      return filteredUsers;
                    });

                    });
                  }
                },
                icon: Image.asset(
                  'icons/filter.png',
                  width: 30,
                  color: Color(0xff4C315C),
                ),
                iconSize: 30,
                color: Color(0xff4C315C),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<User>>(
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
              List<User> users = userSnapshot.data!
                  .where((user) => user.user_id.toString() != widget.user_id)
                  .toList();

              return Container(
                color: Colors.white,
                height: 700,
                width: 500,
                child: Stack(
                  children: [
                    Container(
                      height: 530,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 30,
                              spreadRadius: 0,
                              offset: Offset(0, 10)),
                        ],
                      ),
                    ),
                    if (users.isNotEmpty)
                      Container(
                        height: 570,
                        child: CardSwiper(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          controller: controller,
                          cardBuilder: (context, index, x, y) {
                            try {
                              if (index < 0 || index >= users.length) {
                                throw RangeError('Index out of range');
                              }

                              User user = users[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherProfile(
                                            own_user_id: widget.user_id,
                                            user_id: user.user_id.toString())),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        "images/profile/${user.profile_picture}",
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 340),
                                        color: Color(0xA6967E8C),
                                        padding: EdgeInsets.all(10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${user.nickname}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.7),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      if (user.event_it == null)
                                                        SizedBox.shrink()
                                                      else
                                                        Image.asset(
                                                          "icons/it_badge.png",
                                                          height: 23,
                                                        ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      if (user.event_medicine ==
                                                          null)
                                                        SizedBox.shrink()
                                                      else
                                                        Image.asset(
                                                          "icons/medicine_badge.png",
                                                          height: 23,
                                                        ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      if (user.event_finance ==
                                                          null)
                                                        SizedBox.shrink()
                                                      else
                                                        Image.asset(
                                                          "icons/finance_badge.png",
                                                          height: 23,
                                                        ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      if (user.event_social ==
                                                          null)
                                                        SizedBox.shrink()
                                                      else
                                                        Image.asset(
                                                          "icons/social_badge.png",
                                                          height: 23,
                                                        ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            calculateAge(user
                                                                    .date_of_birth)
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Image.asset(
                                                            user.gender ==
                                                                    'male'
                                                                ? 'icons/male.png'
                                                                : 'icons/female.png',
                                                            height: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Compatibility Score: ${similarityScores[user.user_id.toString()] ?? 'Calculating...'}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      if (user.language !=
                                                          "null")
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.language,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              user.language!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          ],
                                                        )
                                                      else
                                                        SizedBox.shrink(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              width: 160,
                                              margin: EdgeInsets.only(top: 55),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${user.location != 'null' ? user.location : ' - '}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.work,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${user.current_state != 'null' ? user.current_state : ' - '}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              width: 200,
                                              margin: EdgeInsets.only(
                                                  top: 55, left: 170),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.school,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${user.current_state!.toLowerCase() != 'student' ? '${user.school != 'null' ? 'Graduated at ${user.school}' : ' - '}' : (user.school != 'null' ? user.school : ' - ')}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'icons/award.png',
                                                        width: 20,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${user.award != 'null' ? user.award : ' - '}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (user.quote != 'null')
                                              Container(
                                                height: 50,
                                                margin:
                                                    EdgeInsets.only(top: 110),
                                                child: Text(
                                                  '"${user.quote}"',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            else
                                              SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } catch (e) {
                              print("Error in cardBuilder: $e");
                              return Center(child: Text("Error loading user"));
                            }
                          },
                          cardsCount: users.length,
                          scale: 0,
                          numberOfCardsDisplayed: 1,
                          allowedSwipeDirection:
                              AllowedSwipeDirection.symmetric(horizontal: true),
                          onSwipe:
                              (previousIndex, currentIndex, direction) async {
                            User previousUser = users[previousIndex];
                            return await handleSwipeAction(
                                direction, previousUser);
                          },
                        ),
                      )
                    else
                      Center(
                        child: Text(
                            'No users available for the selected filters.'),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 70,
                      margin: EdgeInsets.only(top: 520),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff4C315C),
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  controller.swipe(CardSwiperDirection.left),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff4C315C),
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  controller.swipe(CardSwiperDirection.right),
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
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
