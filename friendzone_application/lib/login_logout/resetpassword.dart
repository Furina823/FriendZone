import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/environment.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    String email = emailController.text;

    if (_validateEmail(email)) {
      var url = Uri.parse('${Env.URL_PREFIX}/password_reset2.php');
      try {
        var response = await http.post(url, body: {'email': email});

        print(response.body);

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect to the server')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
    }
    
  }

  bool _validateEmail(String email) {
    // Simple email validation
    RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color here
      body: _page(),
    );
  }

  Widget _page() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Set the background color for the content area
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _icon(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0), // Adjust left padding as needed
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0), // Adjust left padding as needed
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              _inputField('Input Your Email', emailController),
              const SizedBox(height: 50),
              _resetpasswordBtn(),
              const SizedBox(height: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color(0xFFEEBCE3),
          ),
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'F',
                      style: TextStyle(
                        color: Color(0xFF4C315C), // Color for 'F'
                        fontFamily: 'Itim', // Custom font family
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'riend',
                      style: TextStyle(
                        color: Colors
                            .black, // Matching the text color in the image
                        fontFamily: 'Itim', // Custom font family
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Z',
                      style: TextStyle(
                        color: Color(0xFF4C315C), // Color for 'Z'
                        fontFamily: 'Itim', // Custom font family
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'one',
                      style: TextStyle(
                        color: Colors
                            .black, // Matching the text color in the image
                        fontFamily: 'Itim', // Custom font family
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center, // Centering the text
              ),
              const SizedBox(
                  height:
                      3), // Add some spacing between text and image if needed
              Image.asset(
                'icons/MobileLoginLogo.png',
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          style: const TextStyle(color: Colors.black),
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: enabledBorder,
              focusedBorder: border,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
        ));
  }

  Widget _resetpasswordBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: _resetPassword,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 13),
          backgroundColor:
              const Color(0xFF59396B), // Matching the button color in the image
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
