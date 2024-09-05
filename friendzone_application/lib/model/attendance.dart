import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Attendance {
  int? attendance_id;
  int? event_id;
  int? user_id;

  Attendance({
    required this.attendance_id,
    required this.event_id,
    required this.user_id,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendance_id: json['attendance_id'] as int?,
      event_id: json['event_id'] as int?,
      user_id: json['user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'attendance_id': attendance_id,
    'event_id': event_id,
    'user_id': user_id,
  };
}

Future<List<Attendance>> fetchAttendances() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=attendance'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Attendance.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load attendances');
  }
}

Future<Attendance> fetchAttendance(String id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=attendance&id=$id'));

  if (response.statusCode == 200) {
    return Attendance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load attendance");
  }
}

Future<Attendance> createAttendance(String event_id, String user_id) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=attendance'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "event_id": event_id,
      "user_id": user_id,
    }),
  );

  if (response.statusCode == 201) {
    return Attendance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create attendance.');
  }
}

Future<Attendance> updateAttendance(String attendance_id, String event_id, String user_id) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=attendance&id=$attendance_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "event_id": event_id,
      "user_id": user_id,
    }),
  );

  if (response.statusCode == 200) {
    return Attendance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update attendance.');
  }
}

Future<void> deleteAttendance(String attendance_id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=attendance&id=$attendance_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete attendance.");
  }
}
