import 'package:flutter/material.dart';
import 'event_detail.dart';
import '../model/db_helper.dart';


class SearchEvent extends StatefulWidget {
  const SearchEvent({super.key});

  @override
  State<SearchEvent> createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _filteredItems = [];
  final _searchController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() async {
    final events = await _dbHelper.getFilteredEvents();
    setState(() {
      _filteredItems = events;
    });
  }

  Color _color(String industry) {
    switch (industry.toLowerCase()) {
      case 'it':
        return Color(0x338D00AF);
      case 'medicine':
        return Color(0x33FF564C);
      case 'finance':
        return Color(0x33FABE2C);
      case 'social':
        return Color(0x3372D1FB);
      default:
        return Color(0x3397DE3D) ;
    }
  }

  String _getIndustryIcon(String industry) {
    switch (industry.toLowerCase()) {
      case 'it':
        return 'it_badge.png';
      case 'medicine':
        return 'medicine_badge.png';
      case 'finance':
        return 'finance_badge.png';
      case 'social':
        return 'social_badge.png';
      default:
        return 'male.png';
    }
  }

  void _search() {
    _filterItems();
  }

  // void _navigateToAnotherPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => EventPage()), // Adjust as needed
  //   );
  // }

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
            title: Row(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 40),
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 3),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 40),
                  child: Icon(
                    Icons.search_rounded,
                    color: Color(0xff4C315C),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetail(event_id: item['event_id']),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 23,
                        backgroundColor: _color(item['industry']),
                        child: Image.asset(
                          "icons/${_getIndustryIcon(item['industry'])}",
                          width: 30,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        4), // Optional: Add some space between the title and status
                                Text(
                                  item['industry'] ?? 'industry',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
