import 'dart:convert';
import 'package:http/http.dart' as http;

class SessionManager {
  final String baseUrl;

  SessionManager(this.baseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {'email': email, 'password': password},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> checkSession() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/check_session.php'));
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/logout.php'));
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
