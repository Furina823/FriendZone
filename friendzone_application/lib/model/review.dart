import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/environment.dart';

class Review {
  int? review_id;
  int? user_id;
  int? post_id;

  Review({
    this.review_id,
    this.user_id,
    this.post_id,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      review_id: json['review_id'] as int?,
      user_id: json['user_id'] as int?,
      post_id: json['post_id'] as int?,
    );
  }

  Review.empty();

  Map<String, dynamic> toJson() => {
        'review_id': review_id,
        'user_id': user_id,
        'post_id': post_id,
      };
}

Future<List<Review>> fetchReviews() async {
  final response =
      await http.get(Uri.parse('${Env.URL_PREFIX}/read.php?table=review'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList =
        jsonDecode(response.body)['records'] as List<dynamic>;
    return jsonList
        .map((json) => Review.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load reviews');
  }
}

Future<Review> fetchReview(String id) async {
  final response = await http
      .get(Uri.parse('${Env.URL_PREFIX}/read_single.php?table=review&id=$id'));

  if (response.statusCode == 200) {
    return Review.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load review");
  }
}

Future<Review> createReview(
  String? user_id,
  String? post_id,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/create.php?table=review'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "post_id": post_id,
    }),
  );

  if (response.statusCode == 201) {
    return Review.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    print(response.body);
    print(response.statusCode);
    throw Exception('Failed to create review.');
  }
}

Future<Review> updateReview(
  String review_id,
  String user_id,
  String post_id,
) async {
  final response = await http.post(
    Uri.parse('${Env.URL_PREFIX}/update.php?table=review&id=$review_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id,
      "post_id": post_id,
    }),
  );

  if (response.statusCode == 200) {
    return Review.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update review.');
  }
}

Future<Review> deleteReview(String id) async {
  final response = await http.delete(
    Uri.parse('${Env.URL_PREFIX}/delete.php?table=review&id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Review.empty();
  } else {
    throw Exception("Failed to delete review.");
  }
}
