import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Post {
  int? post_id;
  int? user_id;
  String? post_media;
  String? post_text;
  String? location;
  DateTime? date_time;

  Post({
    this.post_id,
    this.user_id,
    this.post_media,
    this.post_text,
    this.location,
    this.date_time,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      post_id: json['post_id'] as int?,
      user_id: json['user_id'] as int?,
      post_media: json['post_media'] ?? 'null' as String?,
      post_text: json['post_text'] ?? 'null' as String?,
      location: json['location'] ?? 'null' as String?,
      date_time: DateTime.parse(json['date_time'] as String),
    );
  }

  Post.empty();

  Map<String, dynamic> toJson() => {
    'post_id': post_id,
    'user_id': user_id,
    'post_media': post_media,
    'post_text': post_text,
    'location': location,
    'date_time': date_time?.toIso8601String(),
  };
}

Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=post'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<Post> fetchPost(String? id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=post&id=$id'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load post");
  }
}

Future<Post> createPost(
  String? user_id,
  String? post_media,
  String? post_text,
  String? location,
  DateTime? date_time,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=post'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "post_media": post_media,
      "post_text": post_text,
      "location": location,
      "date_time": date_time?.toIso8601String(),
    }),
  );

  if (response.statusCode == 201) {
    return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create post.');
  }
}

Future<Post> updatePost(
  String? post_id,
  String? user_id,
  String? post_media,
  String? post_text,
  String? location,
  DateTime? date_time,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=post&id=${post_id ?? ''}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "post_media": post_media,
      "post_text": post_text,
      "location": location,
      "date_time": date_time?.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update post.');
  }
}

Future<void> deletePost(String? id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=post&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete post.");
  }
}
