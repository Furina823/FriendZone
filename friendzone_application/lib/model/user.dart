import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/environment.dart';

class User {
  int? user_id;
  String? nickname;
  DateTime? date_of_birth;
  String? gender;
  String? email;
  String? password;
  String? current_state;
  String? school;
  String? location;
  String? language;
  String? award;
  String? quote;
  String? profile_picture;
  DateTime? date_time;
  int? event_it;
  int? event_medicine;
  int? event_finance;
  int? event_social;
  

  User({
    this.user_id,
    this.nickname,
    this.date_of_birth,
    this.gender,
    this.email,
    this.password,
    this.current_state,
    this.school,
    this.location,
    this.language,
    this.award,
    this.quote,
    this.profile_picture,
    this.date_time,
    this.event_it,
    this.event_medicine,
    this.event_finance,
    this.event_social
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
    user_id: json['user_id'] as int?,
    nickname: json['nickname'],
    date_of_birth: DateTime.parse(json['date_of_birth']),
    gender: json['gender'],
    email: json['email'],
    password: json['password'],
    current_state: json['current_state'] ?? 'null', // If this field could be null, handle accordingly
    school: json['school'] ?? 'null', // If this field could be null, handle accordingly
    location: json['location'] ?? 'null', // If this field could be null, handle accordingly
    language: json['language'] ?? 'null', // If this field could be null, handle accordingly
    award: json['award'] ?? 'null', // If this field could be null, handle accordingly
    quote: json['quote'] ?? 'null', // If this field could be null, handle accordingly
    profile_picture: json['profile_picture'],
    date_time: DateTime.parse(json['date_time']),
    event_it: json['event_it'] as int?,
    event_medicine: json['event_medicine'] as int?,
    event_finance: json['event_finance'] as int?,
    event_social: json['event_social'] as int?
    );
  }

  User.empty();

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'nickname': nickname,
        'date_of_birth': date_of_birth?.toIso8601String(),
        'gender': gender,
        'email': email,
        'password': password,
        'current_state': current_state,
        'school': school,
        'location': location,
        'language': language,
        'award': award,
        'quote': quote,
        'profile_picture': profile_picture,
        'date_time': date_time?.toIso8601String(),
        'event_it': event_it,
        'event_medicine': event_medicine,
        'event_finance': event_finance,
        'event_social': event_social
      };
}

Future<List<User>> fetchUsers() async {

  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=user'));
  
  if (response.statusCode == 200) {

    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;

    return jsonList.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();

  } else {

    throw Exception('Failed to load users');

  }

}

Future<User> fetchUser(String id ) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=user&id=$id'));
  if(response.statusCode == 200){
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }else{
    
    throw Exception("Failed to load user");
  }
}

Future<User> createUser(
  String nickname,DateTime date_of_birth,String gender,String email,String password,String current_state,String school,
  String location,String language,String award,String quote,String profile_picture,DateTime date_time,
  String? event_it,String? event_medicine,String? event_finance,String? event_social,
) async {

  final response = await http.post(Uri.parse('${Env.URL_PREFIX}/create.php?table=user'),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, dynamic>{
    "nickname": nickname,
    "date_of_birth": date_of_birth.toIso8601String(),
    "gender": gender,"email": email,"password": password,"current_state": current_state,"school": school,"location": location,
    "language": language,"award": award,"quote": quote,"profile_picture": profile_picture,"date_time": date_time.toIso8601String(),
    "event_it": event_it,"event_medicine": event_medicine,"event_finance": event_finance,"event_social": event_social
  }
  )
  );
  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create album.');
  }

}

Future<User> updateUser(
  String user_id,
  String nickname,
  DateTime date_of_birth,
  String gender,
  String email,
  String password,
  String? current_state,
  String? school,
  String? location,
  String? language,
  String? award,
  String? quote,
  String profile_picture,
  DateTime date_time,
  String? event_it,
  String? event_medicine,
  String? event_finance,
  String? event_social
) async {
  try {
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/update.php?table=user&id=${user_id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "nickname": nickname,
        "date_of_birth": date_of_birth.toIso8601String(),
        "gender": gender,
        "email": email,
        "password": password,
        "current_state": current_state ?? null,
        "school": school ?? null,
        "location": location ?? null,
        "language": language ?? null,
        "award": award ?? null,
        "quote": quote ?? null,
        "profile_picture": profile_picture,
        "date_time": date_time.toIso8601String(),
        "event_it": event_it,
        "event_medicine": event_medicine,
        "event_finance": event_finance,
        "event_social": event_social,
      })
    );

    if (response.statusCode == 200) {
      // Assuming the API returns the updated user data
      return User.fromJson(jsonDecode(response.body));
    } else {
      // Handle server errors
      throw Exception('Failed to update user: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle any other errors
    throw Exception('An error occurred: $e');
  }
}

Future<User> deleteUser(String id) async {

  final response = await http.delete(Uri.parse('${Env.URL_PREFIX}/delete.php?table=user&id=$id'),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  
  );

  if(response.statusCode == 200) {

    return User.empty();

  } else {

    throw Exception("Failed to delete user.");

  }

}