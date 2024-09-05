import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/event.dart';
import '../model/business.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Event>> getEventRecommendations(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/event_recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    


    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Business>> fetchBusinesses() async {
    final response = await http.get(Uri.parse('$baseUrl/businesses'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Business.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load businesses');
    }
  }

  
}
