import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class ChatParticipant {
  int chat_id;
  int friend_id;
  int friend_id_2;

  ChatParticipant({
    required this.chat_id,
    required this.friend_id,
    required this.friend_id_2,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      chat_id: json['chat_id'] as int,
      friend_id: json['friend_id'] as int,
      friend_id_2: json['friend_id_2'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'chat_id': chat_id,
        'friend_id': friend_id,
        'friend_id_2': friend_id_2,
      };
}

Future<List<ChatParticipant>> fetchChatParticipants() async {
  final response = await http
      .get(Uri.parse('${Env.URL_PREFIX}/read.php?table=chat_participant'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList =
        jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList
        .map((json) => ChatParticipant.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load chat participants');
  }
}

Future<ChatParticipant> fetchChatParticipant(String chat_id) async {
  final response = await http.get(Uri.parse(
      '${Env.URL_PREFIX}/read_single.php?table=chat_participant&id=$chat_id'));

  if (response.statusCode == 200) {
    return ChatParticipant.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load chat participant");
  }
}

Future<ChatParticipant> createChatParticipant(
    {required String friend_id, required String friend_id_2}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=chat_participant'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "friend_id": friend_id,
      "friend_id_2": friend_id_2,
    }),
  );

  if (response.statusCode == 201) {
    return ChatParticipant.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create chat participant.');
  }
}

Future<void> deleteChatParticipant(String chat_id) async {
  final response = await http.delete(
    Uri.parse(
        '${Env.URL_PREFIX}/delete.php?table=chat_participant&id=$chat_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete chat participant.");
  }
}


