import '../model/db_helper.dart';
import 'package:flutter/material.dart';
import 'signup_page3.dart';

class SignUpPage2 extends StatefulWidget {
  final String nickname;
  final DateTime dob;
  final String gender;
  final String email;
  final String password;

  const SignUpPage2({
    super.key,
    required this.nickname,
    required this.dob,
    required this.gender,
    required this.email,
    required this.password,
  });

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  TextEditingController locationController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController awardController = TextEditingController();
  TextEditingController quoteController = TextEditingController();

  String? selectedState;
  String? selectedSchool;
  String? location;
  String? language;
  String? award;
  String? quote;

  final List<String> states = [
    'IT',
    'Medicine',
    'Finance',
    'Social',
    'Student',
  ];

  Future<List<String>> _getSchools() async {
    List<String> schools = await DBHelper().getSchools();
    return schools.toSet().toList(); // Ensure no duplicate values
  }

  void _signUp() {
    if (selectedState == "Choose Your Current State") {
      selectedState = null;
    }

    if (selectedSchool == "Choose Your School") {
      selectedSchool = null;
    }

    if (locationController.text.isEmpty) {
      location = null;
    } else {
      location = locationController.text;
    }

    if (languageController.text.isEmpty) {
      language = null;
    } else {
      language = languageController.text;
    }

    if (awardController.text.isEmpty) {
      award = null;
    } else {
      award = awardController.text;
    }

    if (quoteController.text.isEmpty) {
      quote = null;
    } else {
      quote = quoteController.text;
    }

    // Navigate to another screen after successful signup
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SignUpPage3(
                nickname: widget.nickname,
                dob: widget.dob,
                gender: widget.gender,
                email: widget.email,
                password: widget.password,
                current_state: selectedState,
                school: selectedSchool,
                location: location,
                language: language,
                award: award,
                quote: quote,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color(0xFFEEBCE3),
          ),
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'F',
                    style: TextStyle(
                      color: Color(0xFF4C315C),
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'riend',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Z',
                    style: TextStyle(
                      color: Color(0xFF4C315C),
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'one',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5.0),
              const Text(
                'Please sign up to continue:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current State',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              _dropdownField('Choose Your Current State', selectedState, states,
                  (String? newValue) {
                setState(() {
                  selectedState = newValue;
                });
              }),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'School',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              FutureBuilder<List<String>>(
                future: _getSchools(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No schools found');
                  } else {
                    List<String> schools = snapshot.data!;
                    schools = schools.toSet().toList();
                    return _dropdownField(
                      'Choose Your School',
                      selectedSchool,
                      schools,
                      (String? newValue) {
                        setState(() {
                          selectedSchool = newValue;
                        });
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Location',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              _inputField('Input Your Location', locationController),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Language',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              _inputField('Input Language You Speak', languageController),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Award',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              _inputField('Input Your Best Award', awardController),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quote',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              _inputField('Input Your Best Quote', quoteController),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59396B),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(String hintText, String? selectedValue,
      List<String> options, ValueChanged<String?> onChanged,
      {Color iconColor = Colors.grey}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF4C315C), width: 2),
    );

    var enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    );

    if (!options.contains(hintText)) {
      options = [hintText, ...options];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        value: selectedValue ?? hintText,
        decoration: InputDecoration(
          hintText: null,
          enabledBorder: enabledBorder,
          focusedBorder: border,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: value == hintText ? Colors.grey : Colors.black,
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: iconColor,
        ),
        isExpanded: true,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF4C315C), width: 2),
    );

    var enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: enabledBorder,
          focusedBorder: border,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
