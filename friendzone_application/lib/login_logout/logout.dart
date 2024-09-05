import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class LogOut extends StatefulWidget {
  final String user_id;

  const LogOut({super.key, required this.user_id});

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  String _msg = '';

  void logout() async {
    String url = "http://10.0.2.2/flutter_api2/api_handlers/logout.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          // Clear user data
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('user_id');

          setState(() {
            _msg = 'Logout successful';
          });

          // Navigate back to login page
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _msg = jsonResponse['message'] ?? 'Logout failed';
          });
        }
      } else {
        setState(() {
          _msg = 'Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _msg = 'An error occurred: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            logout();
          },
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
