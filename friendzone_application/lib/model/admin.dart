import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Admin {
  int? admin_id;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? profile_picture;

  Admin({
    this.admin_id,
    this.username,
    this.email,
    this.phone,
    this.address,
    this.profile_picture,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      admin_id: json['admin_id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      profile_picture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'admin_id': admin_id,
    'username': username,
    'email': email,
    'phone': phone,
    'address': address,
    'profile_picture': profile_picture,
  };
}

Future<List<Admin>> fetchAdmins() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=admin'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Admin.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load admins');
  }
}

Future<Admin> fetchAdmin(String adminId) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=admin&id=$adminId'));

  if (response.statusCode == 200) {
    return Admin.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load admin');
  }
}

Future<Admin> createAdmin({
  required String username,
  required String email,
  required String phone,
  required String address,
  required String profile_picture,
}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=admin'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'profile_picture': profile_picture,
    }),
  );

  if (response.statusCode == 201) {
    return Admin.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create admin');
  }
}

Future<Admin> updateAdmin({
  required String adminId,
  required String username,
  required String email,
  required String phone,
  required String address,
  required String profile_picture,
}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=admin&id=$adminId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'profile_picture': profile_picture,
    }),
  );

  if (response.statusCode == 200) {
    return Admin.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update admin');
  }
}

Future<void> deleteAdmin(String adminId) async {
  final response = await http.delete(Uri.parse('${Env.URL_PREFIX}/delete.php?table=admin&id=$adminId'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete admin');
  }
}
