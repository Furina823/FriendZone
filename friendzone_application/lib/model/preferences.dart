import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Preferences {
  int? user_id;
  String? mbti;
  String? personality;
  String? sport;
  String? food;
  String? fashion;
  String? interest;

  Preferences({
    this.user_id,
    this.mbti,
    this.personality,
    this.sport,
    this.food,
    this.fashion,
    this.interest,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      user_id: json['user_id'] as int?,
      mbti: json['mbti'] as String?,
      personality: json['personality'] as String?,
      sport: json['sport'] as String?,
      food: json['food'] as String?,
      fashion: json['fashion'] as String?,
      interest: json['interest'] as String?,
    );
  }

  Preferences.empty();

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'mbti': mbti,
    'personality': personality,
    'sport': sport,
    'food': food,
    'fashion': fashion,
    'interest': interest,
  };
}

Future<List<Preferences>> fetchPreferences() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=preference'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Preferences.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load preferences');
  }
}

Future<Preferences> fetchPreference(String id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=preference&id=$id'));

  if (response.statusCode == 200) {
    return Preferences.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load preference");
  }
}

Future<Preferences> createPreference(
  String? user_id,
  String? mbti,
  String? personality,
  String? sport,
  String? food,
  String? fashion,
  String? interest,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=preference'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "mbti": mbti,
      "personality": personality,
      "sport": sport,
      "food": food,
      "fashion": fashion,
      "interest": interest,
    }),
  );

  if (response.statusCode == 201) {
    return Preferences.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create preference.');
  }
}

Future<Preferences> updatePreference(
  String? user_id,
  String? mbti,
  String? personality,
  String? sport,
  String? food,
  String? fashion,
  String? interest,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=preference&id=${user_id ?? ''}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "mbti": mbti,
      "personality": personality,
      "sport": sport,
      "food": food,
      "fashion": fashion,
      "interest": interest,
    }),
  );

  if (response.statusCode == 200) {
    return Preferences.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update preference.');
  }
}

Future<void> deletePreference(String id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=preference&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete preference.");
  }
}
