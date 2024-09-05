import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Friend {
  int? friend_id;
  int? user_id;
  int? user_id_2;

  Friend({
    required this.friend_id,
    required this.user_id,
    required this.user_id_2,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friend_id: json['friend_id'] as int?,
      user_id: json['user_id'] as int?,
      user_id_2: json['user_id_2'] as int?,
    );
  }

  Friend.empty();

  Map<String, dynamic> toJson() => {
    'friend_id': friend_id,
    'user_id': user_id,
    'user_id_2': user_id_2,
  };
}

Future<List<Friend>> fetchFriends() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=friend'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Friend.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load friends');
  }
}

Future<Friend> fetchFriend(String id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=friend&id=$id'));

  if (response.statusCode == 200) {
    return Friend.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load friend");
  }
}

Future<Friend> createFriend(
  String user_id,
  String user_id_2,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=friend'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "user_id_2": user_id_2,
    }),
  );

  if (response.statusCode == 201) {
    return Friend.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create friend.');
  }
}

Future<Friend> updateFriend(
  String friend_id,
  String user_id,
  String user_id_2,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=friend&id=$friend_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "user_id_2": user_id_2,
    }),
  );

  if (response.statusCode == 200) {
    return Friend.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update friend.');
  }
}

Future<void> deleteFriend(String id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=friend&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete friend.");
  }
}
