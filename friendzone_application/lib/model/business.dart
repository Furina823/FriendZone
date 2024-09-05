import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Business {
  int business_id;
  String company_name;
  String industry;
  String email;
  String password;
  String phone_number;
  String address;
  String? profile_picture;

  Business({
    required this.business_id,
    required this.company_name,
    required this.industry,
    required this.email,
    required this.password,
    required this.phone_number,
    required this.address,
    this.profile_picture,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      business_id: json['business_id'] as int,
      company_name: json['company_name'] as String,
      industry: json['industry'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone_number: json['phone_number'] as String,
      address: json['address'] as String,
      profile_picture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'business_id': business_id,
    'company_name': company_name,
    'industry': industry,
    'email': email,
    'password': password,
    'phone_number': phone_number,
    'address': address,
    'profile_picture': profile_picture,
  };
}

Future<List<Business>> fetchBusinesses() async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=business'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList.map((json) => Business.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load businesses');
  }
}

Future<Business> fetchBusiness(String id) async {
  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=business&id=$id'));

  if (response.statusCode == 200) {
    return Business.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load business");
  }
}

Future<Business> createBusiness(
  String company_name,
  String industry,
  String email,
  String password,
  String phone_number,
  String address,
  String? profile_picture,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=business'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "company_name": company_name,
      "industry": industry,
      "email": email,
      "password": password,
      "phone_number": phone_number,
      "address": address,
      "profile_picture": profile_picture,
    }),
  );

  if (response.statusCode == 201) {
    return Business.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create business.');
  }
}

Future<Business> updateBusiness(
  String business_id,
  String company_name,
  String industry,
  String email,
  String password,
  String phone_number,
  String address,
  String? profile_picture,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=business&id=$business_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "company_name": company_name,
      "industry": industry,
      "email": email,
      "password": password,
      "phone_number": phone_number,
      "address": address,
      "profile_picture": profile_picture,
    }),
  );

  if (response.statusCode == 200) {
    return Business.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update business.');
  }
}

Future<void> deleteBusiness(String id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=business&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete business.");
  }
}
