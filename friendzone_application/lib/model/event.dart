import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Event {
  int event_id;
  int business_id;
  String title;
  DateTime created_date;
  String quote;
  String media;
  String date_time;
  String location;
  String overview;
  String? objectives;
  String? target_audience;
  String? structure;
  String? material;
  String? benefit;
  String? link;
  String? status;
  String? qr_code;

  Event({
    required this.event_id,
    required this.business_id,
    required this.title,
    required this.created_date,
    required this.quote,
    required this.media,
    required this.date_time,
    required this.location,
    required this.overview,
    this.objectives,
    this.target_audience,
    this.structure,
    this.material,
    this.benefit,
    this.link,
    this.status,
    this.qr_code,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      event_id: json['event_id'] as int,
      business_id: json['business_id'] as int,
      title: json['title'] as String,
      created_date: DateTime.parse(json['created_date']),
      quote: json['quote'] as String,
      media: json['media'] as String,
      date_time: json['date_time'] as String,
      location: json['location'] as String,
      overview: json['overview'] as String,
      objectives: json['objectives'] ?? 'null' as String?, // Nullable String
      target_audience: json['target_audience'] ?? 'null' as String?, // Nullable String
      structure: json['structure'] ?? 'null' as String?,
      material: json['material'] ?? 'null' as String?, // Nullable String
      benefit: json['benefit'] ?? 'null' as String?, // Nullable String
      link: json['link'] ?? 'null' as String?, // Nullable String
      status: json['status'] ?? 'null' as String?, // Nullable String
      qr_code: json['qr_code'] ?? 'null' as String?, // Nullable String
    );
  }

  Map<String, dynamic> toJson() => {
        'event_id': event_id,
        'business_id': business_id,
        'title': title,
        'created_date': created_date.toIso8601String(),
        'quote': quote,
        'media': media,
        'date_time': date_time,
        'location': location,
        'overview': overview,
        'objectives': objectives,
        'target_audience': target_audience,
        'structure': structure,
        'material': material,
        'benefit': benefit,
        'link': link,
        'status': status,
        'qr_code': qr_code,
      };
}

Future<List<Event>> fetchEvents() async {

  final response = await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=event'));
  
  if (response.statusCode == 200) {

    List<dynamic> jsonList = jsonDecode(response.body)['records'] as List<dynamic>;

    return jsonList.map((json) => Event.fromJson(json as Map<String, dynamic>)).toList();

  } else {

    throw Exception('Failed to load events');

  }

}

Future<Event> fetchEvent(int id) async {
  final response = await http
      .get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=event&id=$id'));

  if (response.statusCode == 200) {
    return Event.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load event");
  }
}

Future<Event> createEvent({
  required int business_id,
  required String title,
  required DateTime created_date,
  required String quote,
  required String media,
  required DateTime date_time,
  required String location,
  required String overview,
  String? objectives,
  String? target_audience,
  String? structure,
  String? material,
  String? benefit,
  String? link,
  String? status,
  String? qr_code,
}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=event'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "business_id": business_id,
      "title": title,
      "created_date": created_date.toIso8601String(),
      "quote": quote,
      "media": media,
      "date_time": date_time.toIso8601String(),
      "location": location,
      "overview": overview,
      "objectives": objectives,
      "target_audience": target_audience,
      "structure": structure,
      "material": material,
      "benefit": benefit,
      "link": link,
      "status": status,
      "qr_code": qr_code,
    }),
  );

  if (response.statusCode == 201) {
    return Event.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create event.');
  }
}

Future<Event> updateEvent({
  required int event_id,
  required int business_id,
  required String title,
  required DateTime created_date,
  required String quote,
  required String media,
  required DateTime date_time,
  required String location,
  required String overview,
  String? objectives,
  String? target_audience,
  String? structure,
  String? material,
  String? benefit,
  String? link,
  String? status,
  String? qr_code,
}) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=event&id=$event_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "business_id": business_id,
      "title": title,
      "created_date": created_date.toIso8601String(),
      "quote": quote,
      "media": media,
      "date_time": date_time.toIso8601String(),
      "location": location,
      "overview": overview,
      "objectives": objectives,
      "target_audience": target_audience,
      "structure": structure,
      "material": material,
      "benefit": benefit,
      "link": link,
      "status": status,
      "qr_code": qr_code,
    }),
  );

  if (response.statusCode == 200) {
    return Event.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update event.');
  }
}

Future<void> deleteEvent(int event_id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=event&id=$event_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete event.");
  }
}
