import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Request {
  int? request_id;
  int? user_id;
  int? user_id_2;

  Request({
    this.request_id,
    this.user_id,
    this.user_id_2,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      request_id: json['request_id'] as int?,
      user_id: json['user_id'] as int?,
      user_id_2: json['user_id_2'] as int?,
    );
  }

  Request.empty();

  Map<String, dynamic> toJson() => {
    'request_id': request_id,
    'user_id': user_id,
    'user_id_2': user_id_2,
  };
}

Future<List<Request>> fetchRequests() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=request'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Request.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load requests');
  }
}

Future<Request> fetchRequest(String id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=request&id=$id'));

  if (response.statusCode == 200) {
    return Request.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load request");
  }
}

Future<Request> createRequest(
  String user_id,
  String user_id_2,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=request'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "user_id_2": user_id_2,
    }),
  );

  if (response.statusCode == 201) {
    return Request.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create request.');
  }
}

Future<Request> updateRequest(
  String request_id,
  String user_id,
  String user_id_2,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=request&id=$request_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "user_id_2": user_id_2,
    }),
  );

  if (response.statusCode == 200) {
    return Request.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update request.');
  }
}

Future<Request> deleteRequest(String id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=request&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Request.empty();
  } else {
   throw Exception('Failed to delete request. Response: ${response.statusCode} - ${response.body}');


  }
}
