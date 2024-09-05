import 'package:flutter/material.dart';
import 'package:super_bullet_list/bullet_list.dart';
import 'package:text_scroll/text_scroll.dart';
import '../model/event.dart';
import '../model/business.dart';

class EventDetail extends StatefulWidget {
  final int event_id;

  EventDetail({super.key, required this.event_id});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late Future<List<Business>> futureBusinesses;

  @override
  void initState() {
    super.initState();
    futureBusinesses = fetchBusinesses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: FutureBuilder<Event>(
            future: fetchEvent(widget.event_id),
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No event found.');
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
                        final event = snapshot.data!;

                        Business business = businessSnapshot.data!.firstWhere(
                          (business) =>
                              business.business_id == event.business_id,
                        );

                        String icon_image;

                        switch (business.industry) {
                          case 'IT':
                            icon_image = 'icons/it_badge.png';
                            break;
                          case 'Medicine':
                            icon_image = 'icons/medicine_badge.png';
                            break;
                          case 'Finance':
                            icon_image = 'icons/finance_badge.png';
                          case 'Social':
                            icon_image = 'icons/social_badge.png';
                          default:
                            icon_image =
                                'icons/male.png'; //Change to neutral icon
                        }

                        return Container(
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
                            title: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: TextScroll(
                                  event.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  velocity:
                                      Velocity(pixelsPerSecond: Offset(40, 0)),
                                  pauseBetween: Duration(milliseconds: 500),
                                  numberOfReps: 5,
                                ),
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                ),
                                child: Image.asset(
                                  icon_image,
                                  width: 30,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    });
              }
            }),
      ),
      body: FutureBuilder<Event>(
          future: fetchEvent(widget.event_id),
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No event found.');
            } else {
              final event_detail = snapshot.data!;

              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date, Time & Location",
                              style: TextStyle(
                                color: Color(0xff4C315C),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "icons/date_time.png",
                                  width: 30,
                                  color: Color(0xff4C315C),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextScroll(
                                    event_detail.date_time.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0,
                                    ),
                                    velocity:
                                        Velocity(pixelsPerSecond: Offset(40, 0)),
                                    pauseBetween: Duration(milliseconds: 500),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Color(0xff4C315C),
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextScroll(
                                    event_detail.location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0,
                                    ),
                                    velocity:
                                        Velocity(pixelsPerSecond: Offset(40, 0)),
                                    pauseBetween: Duration(milliseconds: 500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Overview",
                                  style: TextStyle(
                                    color: Color(0xff4C315C),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 190,
                                  child: Flexible(
                                    child: Text(
                                      event_detail.overview,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.justify,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (event_detail.media != 'null')
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage('images/event/${event_detail.media}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              SizedBox.shrink(),
                          ],
                        ),
                      ),
                      if (event_detail.objectives != 'null')
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Objectives",
                                style: TextStyle(
                                  color: Color(0xff4C315C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SuperBulletList(
                                separator: SizedBox(
                                  height: 1,
                                ),
                                iconSize: 7,
                                gap: 10,
                                isOrdered: false,
                                items: event_detail.objectives!
                                    .split(';')
                                    .map((objective) => Text(
                                          objective.trim(),
                                          style: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      SizedBox(
                        height: 5,
                      ),
                      if (event_detail.target_audience != 'null')
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Target Audience",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Image.asset(
                                    "icons/profile.png",
                                    width: 20,
                                    color: Color(0xff4C315C),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SuperBulletList(
                                separator: SizedBox(
                                  height: 2,
                                ),
                                iconSize: 7,
                                gap: 10,
                                isOrdered: false,
                                items: event_detail.target_audience!
                                    .split(';')
                                    .map((objective) => Text(
                                          objective.trim(),
                                          style: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      SizedBox(
                        height: 5,
                      ),
                      if (event_detail.structure != 'null')
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Structure",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "icons/structure.png",
                                    width: 20,
                                    color: Color(0xff4C315C),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SuperBulletList(
                                separator: SizedBox(
                                  height: 1,
                                ),
                                iconSize: 7,
                                gap: 10,
                                isOrdered: false,
                                items: event_detail.structure!
                                    .split(';')
                                    .map((objective) => Text(
                                          objective.trim(),
                                          style: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      SizedBox(
                        height: 5,
                      ),
                      if (event_detail.material != 'null')
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Materials Provided",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "icons/material.png",
                                    width: 20,
                                    color: Color(0xff4C315C),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SuperBulletList(
                                separator: SizedBox(
                                  height: 1,
                                ),
                                iconSize: 7,
                                gap: 10,
                                isOrdered: false,
                                items: event_detail.material!
                                    .split(';')
                                    .map((objective) => Text(
                                          objective.trim(),
                                          style: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      SizedBox(
                        height: 5,
                      ),
                      if (event_detail.benefit != 'null')
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Benefit",
                                    style: TextStyle(
                                      color: Color(0xff4C315C),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "icons/benefit.png",
                                    width: 20,
                                    color: Color(0xff4C315C),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SuperBulletList(
                                separator: SizedBox(
                                  height: 1,
                                ),
                                iconSize: 7,
                                gap: 10,
                                isOrdered: false,
                                items: event_detail.benefit!
                                    .split(';')
                                    .map((objective) => Text(
                                          objective.trim(),
                                          style: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      SizedBox(
                        height: 5,
                      ),
                      if (event_detail.link != 'null')
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event_detail.link!,
                                style: TextStyle(
                                  color: Color(0xff4C315C),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
