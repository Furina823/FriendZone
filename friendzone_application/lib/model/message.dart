import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Message {
  int? message_id;
  int? chat_id;
  int? user_id;
  String? message_text;
  DateTime? date_time;

  Message({
    this.message_id,
    this.chat_id,
    this.user_id,
    this.message_text,
    this.date_time,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message_id: json['message_id'] as int?,
      chat_id: json['chat_id'] as int?,
      user_id: json['user_id'] as int?,
      message_text: json['message_text'] as String?,
      date_time: json['date_time'] != null ? DateTime.parse(json['date_time'] as String) : null,
    );
  }

  Message.empty();

  Map<String, dynamic> toJson() => {
    'message_id': message_id,
    'chat_id': chat_id,
    'user_id': user_id,
    'message_text': message_text,
    'date_time': date_time?.toIso8601String(),
  };
}

Future<List<Message>> fetchMessages() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=message'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Message.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load messages');
  }
}

Future<Message> fetchMessage(String? id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=message&id=$id'));

  if (response.statusCode == 200) {
    return Message.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load message");
  }
}

Future<Message> createMessage(
  String? chat_id,
  String? user_id,
  String? message_text,
  DateTime? date_time,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=message'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "chat_id": chat_id,
      "user_id": user_id,
      "message_text": message_text,
      "date_time": date_time?.toIso8601String(),
    }),
  );

  if (response.statusCode == 201) {
    return Message.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create message.');
  }
}

Future<Message> updateMessage(
  String? message_id,
  String? chat_id,
  String? user_id,
  String? message_text,
  DateTime? date_time,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=message&id=${message_id ?? ''}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "chat_id": chat_id,
      "user_id": user_id,
      "message_text": message_text,
      "date_time": date_time?.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    return Message.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update message.');
  }
}

Future<void> deleteMessage(String? id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=message&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete message.");
  }
}
