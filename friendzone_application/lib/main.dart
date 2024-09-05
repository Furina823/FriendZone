import 'package:flutter/material.dart';
import 'package:friendzone_application/chat/chat.dart';
import 'login_logout/login.dart';
import 'home/homepage.dart';
import 'event/event.dart';
import 'social/social.dart';
import 'model/filter.dart';
import 'profile/self_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Navigation extends StatefulWidget {
  final String user_id;
  
  const Navigation({super.key, required this.user_id});

  @override
  State<Navigation> createState() => _NavigationState();
}


class _NavigationState extends State<Navigation> {
  int currentPage = 2;
  PageController _pageController = PageController(initialPage: 2);
  

  void _onItemTapped(int index) {
    setState(() {
      currentPage = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          //Pages
          SocialPage(user_id: widget.user_id),
          EventPage(user_id: widget.user_id),
          HomePage(
            user_id: widget.user_id,
            filterModel: FilterModel(
                selectedGender: "everyone",
                ageRange: RangeValues(18, 40),
                compatibilityRange: RangeValues(0, 100),
                selectedState: 'All'),
          ),
          ChatPage(user_id: widget.user_id),
          Profile(user_id: widget.user_id),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    _onItemTapped(0);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "icons/social.png",
                        height: 27,
                        color: currentPage == 0
                            ? Color(0xff4C315C)
                            : Color(0xff5D5D5D),
                      ),
                      Text(
                        "Social",
                        style: TextStyle(
                          fontSize: 10,
                          color: currentPage == 0
                              ? Color(0xff4C315C)
                              : Color(0xff5D5D5D),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Spacer(),
                InkWell(
                  onTap: () {
                    _onItemTapped(1);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "icons/event.png",
                        height: 27,
                        color: currentPage == 1
                            ? Color(0xff4C315C)
                            : Color(0xff5D5D5D),
                      ),
                      Text(
                        "Event",
                        style: TextStyle(
                          fontSize: 10,
                          color: currentPage == 1
                              ? Color(0xff4C315C)
                              : Color(0xff5D5D5D),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Spacer(),
                InkWell(
                  onTap: () {
                    _onItemTapped(2);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "icons/home.png",
                        height: 27,
                        color: currentPage == 2
                            ? Color(0xff4C315C)
                            : Color(0xff5D5D5D),
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 10,
                          color: currentPage == 2
                              ? Color(0xff4C315C)
                              : Color(0xff5D5D5D),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Spacer(),
                InkWell(
                  onTap: () {
                    _onItemTapped(3);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "icons/chat.png",
                        height: 27,
                        color: currentPage == 3
                            ? Color(0xff4C315C)
                            : Color(0xff5D5D5D),
                      ),
                      Text(
                        "Chat",
                        style: TextStyle(
                          fontSize: 10,
                          color: currentPage == 3
                              ? Color(0xff4C315C)
                              : Color(0xff5D5D5D),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Spacer(),
                InkWell(
                  onTap: () {
                    _onItemTapped(4);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "icons/profile.png",
                        height: 27,
                        color: currentPage == 4
                            ? Color(0xff4C315C)
                            : Color(0xff5D5D5D),
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 10,
                          color: currentPage == 4
                              ? Color(0xff4C315C)
                              : Color(0xff5D5D5D),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
