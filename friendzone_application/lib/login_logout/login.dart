import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'resetpassword.dart';
import 'signup_page.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Future<void> onRefresh() async {
    setState(() {
      Login();
    });
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_validateEmail(email) && _validatePassword(password)) {
      setState(() {
        _isLoading = true; // Show the loading indicator
      });

      String url = "http://10.0.2.2/flutter_api2/api_handlers/login.php";
      final Map<String, String> queryParams = {
        "email": email,
        "password": password,
      };

      try {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'] == 'success') {
            final List<dynamic> userList = jsonResponse['data'];

            if (userList.isNotEmpty) {
              final user = userList[0];
              final userId = user['user_id']; // This might be an integer

              // Convert user_id to string if needed
              final userIdStr = userId.toString();

              // Store user info
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_id', userIdStr);

              // Navigate to HomePage with user id
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Navigation(user_id: userIdStr),
                ),
              );
            } else {
              setState(() {
                print('Invalid email or password');
              });
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Incorrect email or password')),
            );
          }
        } else {
          setState(() {
            print('Error: ${response.statusCode}');
          });
        }
      } catch (error) {
        setState(() {
          print('An error occurred: $error');
        });
      } finally {
        setState(() {
          _isLoading = false; // Hide the loading indicator
        });
      }
    } else {
      // Show an error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid email and password')),
      );
    }
  }

  bool _validateEmail(String email) {
    // Simple email validation
    RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  bool _validatePassword(String password) {
    // Password must be at least 8 characters
    return password.length >= 8;
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color here
      body: RefreshIndicator(onRefresh: onRefresh, child: SingleChildScrollView(child: _page())),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Container(
              color:
                  Colors.white, // Set the background color for the content area
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
                        'Please login to continue:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  _inputField('Input Your Email', _emailController),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0), // Adjust left padding as needed
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _inputField('Input Your Password', _passwordController,
                      isPasswordField: true),
                  const SizedBox(height: 8),
                  _forgotPasswordLink(),
                  const SizedBox(height: 5),
                  _loginBtn(),
                  const SizedBox(height: 3),
                  _signUpLink(),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) // Show CircularProgressIndicator if loading
          Center(
            child: Container(
              child: const CircularProgressIndicator(),
            ),
          ),
      ],
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

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPasswordField = false}) {
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
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null,
        ),
        obscureText: isPasswordField && !isPasswordVisible,
      ),
    );
  }

  Widget _forgotPasswordLink() {
    return TextButton(
      onPressed: _forgotPassword,
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF4C315C),
        ),
      ),
    );
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResetPasswordPage()), // Corrected to ResetPasswordPage
    );
  }

  Widget _loginBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 13),
          backgroundColor:
              const Color(0xFF59396B), // Matching the button color in the image
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Log In",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _signUpLink() {
    return TextButton(
      onPressed: _signUp,
      child: RichText(
        text: const TextSpan(
          text: 'If you wish to create a new account, ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'sign up',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4C315C),
              ),
            ),
            TextSpan(
              text: ' now!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
