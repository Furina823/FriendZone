import 'package:flutter/material.dart';
import 'package:friendzone_application/event/search_event.dart';
import 'package:intl/intl.dart';
import 'event_detail.dart';
import 'event_recommendation_api.dart';
import '../model/business.dart';
import '../model/event.dart';
import 'qr_scan.dart';

class EventPage extends StatefulWidget {
  final String user_id;

  const EventPage({super.key, required this.user_id});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future<List<Event>> futureEvents;
  late Future<List<Business>> futureBusinesses;
  late Future<List<Event>> futureRecommendedEvents;
  String selectedCategory = 'All';

  final ApiService apiService = ApiService('http://10.0.2.2:5000');

  String formatDateTime(String event_date_time) {
    List<String> parts = event_date_time.split(' ');
    String date = parts[0];
    String time = parts[1];

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime event_date = DateFormat('yyyy-MM-dd').parse(date);
    String format_date = dateFormat.format(event_date);

    List<String> timeRange = time.split('-');
    if (timeRange.length != 2) {
      throw FormatException('Invalid time range format');
    }
    String start_time = timeRange[0];
    String end_time = timeRange[1];

    return '$format_date | $start_time - $end_time';
  }

  bool upcomingEvent(String event_date) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime now = DateTime.now();

    List<String> parts = event_date.split(' ');
    DateTime date = dateFormat.parse(parts[0]);
    return date.isAfter(now);
  }

  void filterEvent(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
    futureBusinesses = fetchBusinesses();
    futureRecommendedEvents =
        apiService.getEventRecommendations(widget.user_id);
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
                    MaterialPageRoute(builder: (context) => SearchEvent(),),
                  );
                },
                icon: Icon(Icons.search_rounded),
                iconSize: 30,
                color: Color(0xff4C315C),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QrScan(user_id: widget.user_id)),
                  );
                },
                child: Image.asset(
                  'icons/qr_scan.png',
                  width: 25,
                  color: Color(0xff4C315C),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Event>>(
        future: futureRecommendedEvents,
        builder: (context, recommendedEventSnapshot) {
          if (recommendedEventSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (recommendedEventSnapshot.hasError) {
            return Center(
              child: Text("Error: ${recommendedEventSnapshot.error}"),
            );
          } else if (!recommendedEventSnapshot.hasData ||
              recommendedEventSnapshot.data!.isEmpty) {
            return Center(
              child: Text("No recommended events found."),
            );
          } else {
            return FutureBuilder<List<Business>>(
              future: futureBusinesses,
              builder: (context, businessSnapshot) {
                if (businessSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (businessSnapshot.hasError) {
                  return Center(
                    child: Text("Error: ${businessSnapshot.error}"),
                  );
                } else if (!businessSnapshot.hasData ||
                    businessSnapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No business found."),
                  );
                } else {
                  List<Event> events = recommendedEventSnapshot.data!
                      .where((event) => upcomingEvent(event.date_time))
                      .where((event) => event.status == "upcoming")
                      .toList();

                  if (selectedCategory != 'All') {
                    events = events.where((event) {
                      Business business = businessSnapshot.data!.firstWhere(
                        (business) => business.business_id == event.business_id,
                      );
                      return business.industry == selectedCategory;
                    }).toList();
                  }

                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(7, 15, 7, 30),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () => filterEvent('All'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0x3397DE3D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(80, 40),
                                  ),
                                  child: Text(
                                    'All',
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton.icon(
                                  onPressed: () => filterEvent('IT'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0x338D00AF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(80, 40),
                                  ),
                                  icon: Image.asset(
                                    'icons/it_badge.png',
                                    width: 25,
                                  ),
                                  label: Text(
                                    "IT",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton.icon(
                                  onPressed: () => filterEvent('Medicine'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0x33FF564C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(90, 40),
                                  ),
                                  icon: Image.asset(
                                    'icons/medicine_badge.png',
                                    width: 25,
                                  ),
                                  label: Text(
                                    "Medicine",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton.icon(
                                  onPressed: () => filterEvent('Finance'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0x33FABE2C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(90, 40),
                                  ),
                                  icon: Image.asset(
                                    'icons/finance_badge.png',
                                    width: 25,
                                  ),
                                  label: Text(
                                    "Finance",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton.icon(
                                  onPressed: () => filterEvent('Social'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0x3372D1FB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(90, 40),
                                  ),
                                  icon: Image.asset(
                                    'icons/social_badge.png',
                                    width: 25,
                                  ),
                                  label: Text(
                                    "Social",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                Event event = events[index];

                                Business business =
                                    businessSnapshot.data!.firstWhere(
                                  (business) =>
                                      business.business_id == event.business_id,
                                );

                                Color divcolor;
                                ImageProvider industry_image;
                                String icon_image;
                                Color icon_color;

                                switch (business.industry) {
                                  case 'IT':
                                    divcolor = Color(0xffEEBCE3);
                                    industry_image =
                                        AssetImage("images/it.png");
                                    icon_image = 'icons/it_badge.png';
                                    icon_color = Color(0xff8D00AF);
                                    break;
                                  case 'Medicine':
                                    divcolor = Color(0x33FF564C);
                                    industry_image =
                                        AssetImage("images/medicine.png");
                                    icon_image = 'icons/medicine_badge.png';
                                    icon_color = Color(0xffFF564C);
                                    break;
                                  case 'Finance':
                                    divcolor = Color(0x33FABE2C);
                                    industry_image =
                                        AssetImage("images/finance.png");
                                    icon_image = 'icons/finance_badge.png';
                                    icon_color = Color(0xffFABE2C);
                                    break;
                                  case 'Social':
                                    divcolor = Color(0x3372D1FB);
                                    industry_image =
                                        AssetImage("images/social.png");
                                    icon_image = 'icons/social_badge.png';
                                    icon_color = Color(0xff72D1FB);
                                    break;
                                  default:
                                    divcolor = Color(0x3397DE3D);
                                    industry_image =
                                        AssetImage("images/logo.png");
                                    icon_image = 'icons/male.png';
                                    icon_color = Color(0xff97DE3D);
                                    break;
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventDetail(
                                              event_id: event.event_id)),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    height: 140,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: divcolor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        Container(
                                          height: 85,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(
                                            left: 220,
                                            top: 35,
                                          ),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: industry_image,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                            left: 10,
                                            right: 5,
                                            top: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    icon_image,
                                                    width: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                      event.title,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 250,
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            '"${event.quote}"',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xff4C315C),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "icons/date_time.png",
                                                          width: 25,
                                                          color: icon_color,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            formatDateTime(event
                                                                .date_time),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: icon_color,
                                                          size: 24,
                                                        ),
                                                        SizedBox(width: 7),
                                                        Expanded(
                                                          child: Text(
                                                            event.location,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  -0.5,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
