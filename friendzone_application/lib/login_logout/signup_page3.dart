import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'preference.dart';
import 'package:path/path.dart' as path;
import '../model/user.dart';

class SignUpPage3 extends StatefulWidget {
  final String nickname;
  final DateTime dob;
  final String gender;
  final String email;
  final String password;
  final String? current_state;
  final String? school;
  final String? location;
  final String? language;
  final String? award;
  final String? quote;

  const SignUpPage3({
    super.key,
    required this.nickname,
    required this.dob,
    required this.gender,
    required this.email,
    required this.password,
    this.current_state,
    this.school,
    this.location,
    this.language,
    this.award,
    this.quote,
  });

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  bool isPictureUploaded = false;
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result!.files.first;
        _fileName = path.basename(file.path!); // Get only the file name
        pickedfile = file;
        fileToDisplay = File(file.path!);
        isPictureUploaded = true; // Mark picture as uploaded
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void clearFile() {
    setState(() {
      _fileName = null;
      pickedfile = null;
      fileToDisplay = null;
      isPictureUploaded = false; // Reset picture upload status
    });
  }

  void _signUp() async {
    if (isPictureUploaded && fileToDisplay != null) {
      String picture = _fileName!;

      try {

        User newUser = User(
        nickname: widget.nickname,
        date_of_birth: widget.dob,
        gender: widget.gender,
        email: widget.email,
        password: widget.password,
        current_state: widget.current_state,
        school: widget.school,
        location: widget.location,
        language: widget.language,
        award: widget.award,
        quote: widget.quote,
        profile_picture: picture,

        );

        // Proceed to the next page, e.g., the preference page, passing the user_id
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Preference(user: newUser),
          ),
        );

        // Clear the file after successful sign-up
        clearFile();
      } catch (e) {
        // Show an error message if the user creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Submission')),
        );
      }
    } else {
      // Show an error message if the picture is not uploaded
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a profile picture')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
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
            children: [
              const SizedBox(height: 2.0),
              const Text(
                'Please sign up to continue:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Profile Picture',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: pickFile,
                  child: Stack(
                    children: [
                      Container(
                        width: 250,
                        height: 397,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: _fileName != null
                              ? Image.file(
                                  fileToDisplay!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.add_rounded,
                                  size: 100,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      if (_fileName != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              clearFile();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: const Text(
                  'Please upload a clear picture of yourself.\nLet us make it personal and authentic!',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
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
}
