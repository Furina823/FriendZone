import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Comment {
  int comment_id;
  int post_id;
  int user_id;
  String comment_text;
  DateTime date_time;

  Comment({
    required this.comment_id,
    required this.post_id,
    required this.user_id,
    required this.comment_text,
    required this.date_time,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment_id: json['comment_id'] as int,
      post_id: json['post_id'] as int,
      user_id: json['user_id'] as int,
      comment_text: json['comment_text'] as String,
      date_time: DateTime.parse(json['date_time']),
    );
  }

  Map<String, dynamic> toJson() => {
    'comment_id': comment_id,
    'post_id': post_id,
    'user_id': user_id,
    'comment_text': comment_text,
    'date_time': date_time.toIso8601String(),
  };
}

Future<List<Comment>> fetchComments() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=comment'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Comment.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load comments');
  }
}

Future<Comment> fetchComment(String id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=comment&id=$id'));

  if (response.statusCode == 200) {
    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load comment");
  }
}

Future<Comment> createComment({
  required String post_id,
  required String user_id,
  required String comment_text,
  required DateTime date_time,
}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=comment'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "post_id": post_id,
      "user_id": user_id,
      "comment_text": comment_text,
      "date_time": date_time.toIso8601String(),
    }),
  );

  if (response.statusCode == 201) {
    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create comment.');
  }
}

Future<Comment> updateComment({
  required String comment_id,
  required String post_id,
  required String user_id,
  required String comment_text,
  required DateTime date_time,
}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=comment&id=$comment_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "post_id": post_id,
      "user_id": user_id,
      "comment_text": comment_text,
      "date_time": date_time.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update comment.');
  }
}

Future<void> deleteComment(String comment_id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=comment&id=$comment_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete comment.");
  }
}
