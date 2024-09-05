import '../model/preferences.dart';
import '../model/post.dart';

Future<Set<String>> profileImages(String userId) async {
  var postSet = <String>{};

  try {
    List<Post> posts = await fetchPosts();
    DateTime now = DateTime.now();

    posts = posts
        .where((post) => post.user_id.toString() == userId)
        .where((post) => post.date_time!.isBefore(now))
        .toList()
      ..sort((a, b) => b.date_time!.compareTo(a.date_time!));

    for (Post post in posts) {
      var media = post.post_media?.toString();
      var text = post.post_text?.toString();

      if (media != null && media.isNotEmpty && media != "null") {
        postSet.add(media);
      } else if ((media == null || media == "null") &&
          text != null &&
          text.isNotEmpty &&
          text != "null") {
        postSet.add(text);
      }
    }
  } catch (e) {
    print('Error fetching posts: $e');
  }

  print(postSet);
  return postSet;
}

Future<Set<String>> profileImageId(String userId) async {
  var postSet = <String>{};

  try {
    List<Post> posts = await fetchPosts();
    DateTime now = DateTime.now();

    posts = posts
        .where((post) => post.user_id.toString() == userId)
        .where((post) => post.date_time!.isBefore(now))
        .toList()
      ..sort((a, b) => b.date_time!.compareTo(a.date_time!));

    for (Post post in posts) {
      var id = post.post_id?.toString();

      if (id != null && id.isNotEmpty && id != "null") {
        postSet.add(id);
      } 
    }
  } catch (e) {
    print('Error fetching posts: $e');
  }

  print(postSet);
  return postSet;
}

Future<Map<String, List<String>>> getPreference(String userId) async {
  final Preferences preference = await fetchPreference(userId);

  // Helper function to capitalize each word in a string
  String capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  return {
    'Personality': [
      capitalizeWords((preference.personality ?? '').replaceAll(',', '  '))
    ],
    'Sport': [capitalizeWords((preference.sport ?? '').replaceAll(',', '  '))],
    'Interest': [
      capitalizeWords((preference.interest ?? '').replaceAll(',', '  '))
    ],
    'Food': [capitalizeWords((preference.food ?? '').replaceAll(',', '  '))],
    'Fashion': [
      capitalizeWords((preference.fashion ?? '').replaceAll(',', '  '))
    ],
  };
}
