import 'package:flutter/material.dart';
import '../model/attendance.dart';
import '../model/business.dart';
import '../model/event.dart';
import 'slidenavigation.dart';
import '../model/user.dart';
import 'self_profile.dart';
import 'package:flutter/cupertino.dart';

class EditProfile extends StatefulWidget {
  final String user_id;
  final VoidCallback onSave;

  const EditProfile({super.key, required this.user_id, required this.onSave});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<User> futureUser;
  User? _currentUser;

  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _quoteController = TextEditingController();
  final _locationController = TextEditingController();
  final _currentStateController = TextEditingController();
  final _schoolController = TextEditingController();
  final _awardController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _languageController = TextEditingController();

  late int _selectedEventIT = 0;
  late int _selectedEventFinance = 0;
  late int _selectedEventSocial = 0;
  late int _selectedEventMedicine = 0;

  String? selectedEventTitleIT;
  String? selectedEventTitleFinance;
  String? selectedEventTitleSocial;
  String? selectedEventTitleMedicine;

  User? _user;

  List<Event> _eventsIT = [];
  List<Event> _eventsFinance = [];
  List<Event> _eventsSocial = [];
  List<Event> _eventsMedicine = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData().then((_) {
      _fetchEvents().then((_) {
        setState(() {
          // Set initial dropdown values based on the event titles
          _loadUserEventTitles();
        });
      });
    });
    futureUser = fetchUser(widget.user_id);
    futureUser.then((user) {
      setState(() {
        _currentUser = user;
        _nicknameController.text = user.nickname ?? "";
        _quoteController.text = user.quote ?? "";
        _locationController.text = user.location ?? "";
        _currentStateController.text = user.current_state ?? "";
        _languageController.text = user.language ?? "";
        _schoolController.text = user.school ?? "";
        _awardController.text = user.award ?? "";
        _dateOfBirthController.text = user.date_of_birth != null
            ? user.date_of_birth.toString().split(' ')[0]
            : "";
        _dateTimeController.text = user.date_time != null
            ? user.date_time.toString().split(' ')[0]
            : "";
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _quoteController.dispose();
    _locationController.dispose();
    _currentStateController.dispose();
    _languageController.dispose();
    _schoolController.dispose();
    _awardController.dispose();
    _dateOfBirthController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      _user = await fetchUser(widget.user_id);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final eventMap = await getReward(widget.user_id);
      setState(() {
        _eventsIT = eventMap.entries
            .where((entry) => entry.value.industry == 'IT')
            .map((entry) => entry.key)
            .toList();
        _eventsFinance = eventMap.entries
            .where((entry) => entry.value.industry == 'Finance')
            .map((entry) => entry.key)
            .toList();
        _eventsSocial = eventMap.entries
            .where((entry) => entry.value.industry == 'Social')
            .map((entry) => entry.key)
            .toList();
        _eventsMedicine = eventMap.entries
            .where((entry) => entry.value.industry == 'Medicine')
            .map((entry) => entry.key)
            .toList();

        final noneEvent = Event(
          event_id: 0,
          business_id: 0,
          title: 'None',
          created_date: DateTime.now(),
          quote: '',
          media: '',
          date_time: '',
          location: '',
          overview: '',
        );

        _eventsIT.insert(0, noneEvent);
        _eventsFinance.insert(0, noneEvent);
        _eventsSocial.insert(0, noneEvent);
        _eventsMedicine.insert(0, noneEvent);
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  int _getInitialIndex(List<Event> events, String? title) {
    if (title == null) {
      return 0; // Default to the first index if title is null
    }

    // Find the index of the event with the matching title
    for (int i = 0; i < events.length; i++) {
      if (events[i].title == title) {
        return i;
      }
    }

    return 0; // Default to the first index if no matching title is found
  }

  List<String> eventTitles = []; // List to hold event titles

  Future<String?> fetchEventTitleById(int eventId) async {
    Event event = await fetchEvent(eventId);

    if (event.event_id == eventId) return event.title;

    return null;
  }

  Future<void> _loadUserEventTitles() async {
    // Assuming you have a function to fetch event title by event_id
    if (_user?.event_it != null) {
      selectedEventTitleIT = await fetchEventTitleById(_user!.event_it!);
    }
    if (_user?.event_finance != null) {
      selectedEventTitleFinance =
          await fetchEventTitleById(_user!.event_finance!);
    }
    if (_user?.event_social != null) {
      selectedEventTitleSocial =
          await fetchEventTitleById(_user!.event_social!);
    }
    if (_user?.event_medicine != null) {
      selectedEventTitleMedicine =
          await fetchEventTitleById(_user!.event_medicine!);
    }

    // Set the initial index for dropdowns based on the event titles
    setState(() {
      _selectedEventIT = _getInitialIndex(_eventsIT, selectedEventTitleIT);
      _selectedEventFinance =
          _getInitialIndex(_eventsFinance, selectedEventTitleFinance);
      _selectedEventSocial =
          _getInitialIndex(_eventsSocial, selectedEventTitleSocial);
      _selectedEventMedicine =
          _getInitialIndex(_eventsMedicine, selectedEventTitleMedicine);
    });
  }

  double _kItemExtent = 32.0;

  Future<List<Event>> getFilteredEventsByIndustry(
      String ownId, String industryFilter) async {
    try {
      // Fetch data from sources
      List<Event> events = await fetchEvents();
      List<Business> businesses = await fetchBusinesses();
      List<Attendance> attendances = await fetchAttendances();

      // Filter attendances for the specified user
      List<Attendance> filteredAttendance = attendances
          .where((attendance) => attendance.user_id.toString() == ownId)
          .toList();

      // Create a map for fast lookup of businesses by their ID
      Map<String, Business> businessMap = {
        for (var business in businesses)
          business.business_id.toString(): business
      };

      // Find events where the associated business's industry matches the filter
      List<Event> filteredEvents = [];

      for (Attendance attendance in filteredAttendance) {
        Event? event = events.firstWhere(
          (event) => attendance.event_id == event.event_id,
        );

        if (event != null) {
          Business? business = businessMap[event.business_id];

          if (business != null && business.industry == industryFilter) {
            filteredEvents.add(event);
          }
        }
      }

      // Optional: Log the filtered events (for debugging purposes)
      for (Event event in filteredEvents) {
        print(
            'Event ID: ${event.event_id}, Title: ${event.title}, Industry: ${industryFilter}');
      }

      return filteredEvents;
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<Map<Event, Business>> getReward(String ownId) async {
    try {
      List<Event> events = await fetchEvents();
      List<Attendance> attendances = await fetchAttendances();

      List<Attendance> filteredAttendance = attendances
          .where((attendance) => attendance.user_id.toString() == ownId)
          .toList();

      Map<Event, Business> relationship = {};

      for (Attendance attendance in filteredAttendance) {
        for (Event event in events) {
          if (attendance.event_id == event.event_id) {
            Business business =
                await fetchBusiness(event.business_id.toString());
            relationship[event] = business;
          }
        }
      }

      print(
          'Retrieved events: ${relationship.keys.map((e) => e.title).toList()}');

      return relationship;
    } catch (e) {
      print('Error in getReward: $e');
      return {};
    }
  }

  bool validateRewardSelection() {
    bool isValid = true;

    if ((_eventsIT.isNotEmpty && _selectedEventIT >= _eventsIT.length) ||
        _eventsIT.isEmpty ||
        _eventsIT[_selectedEventIT].event_id == 0) {
      isValid = false;
    }

    if ((_eventsMedicine.isNotEmpty &&
            _selectedEventMedicine >= _eventsMedicine.length) ||
        _eventsMedicine.isEmpty ||
        _eventsMedicine[_selectedEventMedicine].event_id == 0) {
      isValid = false;
    }

    if ((_eventsFinance.isNotEmpty &&
            _selectedEventFinance >= _eventsFinance.length) ||
        _eventsFinance.isEmpty ||
        _eventsFinance[_selectedEventFinance].event_id == 0) {
      isValid = false;
    }

    if ((_eventsSocial.isNotEmpty &&
            _selectedEventSocial >= _eventsSocial.length) ||
        _eventsSocial.isEmpty ||
        _eventsSocial[_selectedEventSocial].event_id == 0) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final int? eventIt = (_eventsIT.isNotEmpty &&
              _selectedEventIT < _eventsIT.length &&
              _eventsIT[_selectedEventIT].event_id != 0)
          ? _eventsIT[_selectedEventIT].event_id
          : null;

      final int? eventMedicine = (_eventsMedicine.isNotEmpty &&
              _selectedEventMedicine < _eventsMedicine.length &&
              _eventsMedicine[_selectedEventMedicine].event_id != 0)
          ? _eventsMedicine[_selectedEventMedicine].event_id
          : null;

      final int? eventFinance = (_eventsFinance.isNotEmpty &&
              _selectedEventFinance < _eventsFinance.length &&
              _eventsFinance[_selectedEventFinance].event_id != 0)
          ? _eventsFinance[_selectedEventFinance].event_id
          : null;

      final int? eventSocial = (_eventsSocial.isNotEmpty &&
              _selectedEventSocial < _eventsSocial.length &&
              _eventsSocial[_selectedEventSocial].event_id != 0)
          ? _eventsSocial[_selectedEventSocial].event_id
          : null;

      User user = User(
        user_id: int.parse(widget.user_id),
        nickname: _nicknameController.text,
        date_of_birth: DateTime.parse(_dateOfBirthController.text),
        gender: _currentUser?.gender ?? "",
        email: _currentUser?.email ?? "",
        password: _currentUser?.password ?? "",
        current_state: _currentStateController.text,
        school: _schoolController.text,
        location: _locationController.text,
        language: _languageController.text,
        award: _awardController.text,
        quote: _quoteController.text,
        profile_picture: _currentUser?.profile_picture ?? "",
        date_time: DateTime.parse(_dateTimeController.text),
        event_it: eventIt,
        event_medicine: eventMedicine,
        event_finance: eventFinance,
        event_social: eventSocial,
      );

      try {
        await updateUser(
            widget.user_id,
            user.nickname ?? "",
            user.date_of_birth ?? DateTime.now(),
            user.gender ?? "",
            user.email ?? "",
            user.password ?? "",
            user.current_state ?? "",
            user.school ?? "",
            user.location ?? "",
            user.language ?? "",
            user.award ?? "",
            user.quote ?? "",
            user.profile_picture ?? "",
            user.date_time ?? DateTime.now(),
            user.event_it?.toString(),
            user.event_medicine?.toString(),
            user.event_finance?.toString(),
            user.event_social?.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
       Navigator.push(context, SlideTransitionPageRoute(page: Profile(user_id: widget.user_id,)));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated sucessfully')),
        );
        Navigator.push(context, SlideTransitionPageRoute(page: Profile(user_id: widget.user_id,)));
      }
    }
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
              "Edit Profile",
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    User user = snapshot.data!;
                    _currentUser = user;
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Profile"),
                          _buildTextField(_nicknameController, "Nickname",
                              "Please enter a nickname"),
                          _buildTextField(_quoteController, "Bio"),
                          _buildTextField(_locationController, "Location"),
                          _buildTextField( _currentStateController, "Current State"),
                          _buildTextField(_languageController, "Language"),
                          _buildEducationField(),
                          _buildTextField(_awardController, "Award"),
                          _buildEventRewards(),
                          _buildSaveButton(),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            color: Color(0xff747474),
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [String? validatorMessage]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff9D9D9D), width: 2.0),
          borderRadius: BorderRadius.circular(16),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
                color: Color(0xff5D5D5D),
                fontWeight: FontWeight.w500,
                fontSize: 17),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                  color: Color(0xff9D9D9D),
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
              border: InputBorder.none,
            ),
            validator: validatorMessage != null
                ? (value) {
                    if (value == null || value.isEmpty || value == "null") {
                      return validatorMessage;
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildEducationField() {
    return Container(
      child: Stack(
        children: [
          _buildTextField(
            _schoolController,
            "Education",
          ),
          if (_currentStateController.text != "Student")
            Container(
              margin: EdgeInsets.only(top: 15, left: 240),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 20, color: Color(0xff4C315C),),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Graduated"),
                ],
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }

  Widget _buildEventRewards() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff9D9D9D), width: 2.0),
          borderRadius: BorderRadius.circular(16),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text("Event Reward",
                    style: TextStyle(
                        color: Color(0xff9D9D9D),
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
              _buildEventRow("it_badge.png", _eventsIT, _selectedEventIT,
                  (selectedItem) {
                setState(() {
                  _selectedEventIT = selectedItem;
                });
              }),
              _buildEventRow(
                  "medicine_badge.png", _eventsMedicine, _selectedEventMedicine,
                  (selectedItem) {
                setState(() {
                  _selectedEventMedicine = selectedItem;
                });
              }),
              _buildEventRow(
                  "finance_badge.png", _eventsFinance, _selectedEventFinance,
                  (selectedItem) {
                setState(() {
                  _selectedEventFinance = selectedItem;
                });
              }),
              _buildEventRow(
                  "social_badge.png", _eventsSocial, _selectedEventSocial,
                  (selectedItem) {
                setState(() {
                  _selectedEventSocial = selectedItem;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventRow(String imagePath, List<Event> events, int selectedEvent,
      Function(int) onSelectedItemChanged) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          width: 35,
          child: Center(
            child: Image.asset("icons/$imagePath"),
          ),
        ),
        Expanded(
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showDialog(
              CupertinoPicker(
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: _kItemExtent,
                scrollController:
                    FixedExtentScrollController(initialItem: selectedEvent),
                onSelectedItemChanged: onSelectedItemChanged,
                children: List<Widget>.generate(
                  events.length,
                  (int index) => Center(child: Text(events[index].title)),
                ),
              ),
            ),
            child: Text(
              events.isNotEmpty ? events[selectedEvent].title : '- - -',
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: saveProfile,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xff4C315C)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
