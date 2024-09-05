import '../model/preferences.dart';

class SimilarityCalculator {
  final Preferences user1;
  final Preferences user2;

  SimilarityCalculator(this.user1, this.user2);

  int calculateSimilarity({
    double mbtiWeight = 1.0,
    double personalityWeight = 1.0,
    double sportWeight = 1.0,
    double foodWeight = 1.0,
    double fashionWeight = 1.0,
    double interestWeight = 1.0,
  }) {
    double score = 0;

    if (user1.mbti == user2.mbti) {
      score += mbtiWeight;
    }

    score += _calculateListWeightedSimilarity(user1.personality, user2.personality) * personalityWeight;
    score += _calculateListWeightedSimilarity(user1.sport, user2.sport) * sportWeight;
    score += _calculateListWeightedSimilarity(user1.food, user2.food) * foodWeight;
    score += _calculateListWeightedSimilarity(user1.fashion, user2.fashion) * fashionWeight;
    score += _calculateListWeightedSimilarity(user1.interest, user2.interest) * interestWeight;

    double maxScore = _calculateMaxScore(mbtiWeight, personalityWeight, sportWeight, foodWeight, fashionWeight, interestWeight);

    return ((score / maxScore) * 100).round();  // Return as an integer
  }

  double _calculateMaxScore(double mbtiWeight, double personalityWeight, double sportWeight, 
                             double foodWeight, double fashionWeight, double interestWeight) {
    double maxScore = 0;
    if (user1.mbti != null) maxScore += mbtiWeight;
    maxScore += _countOptions(user1.personality) * personalityWeight;
    maxScore += _countOptions(user1.sport) * sportWeight;
    maxScore += _countOptions(user1.food) * foodWeight;
    maxScore += _countOptions(user1.fashion) * fashionWeight;
    maxScore += _countOptions(user1.interest) * interestWeight;
    return maxScore;
  }

  int _countOptions(String? list) {
    if (list == null || list.isEmpty) return 0;
    return list.split(',').length;
  }

  int _calculateListWeightedSimilarity(String? list1, String? list2) {
    if (list1 == null || list2 == null) return 0;
    List<String> options1 = list1.split(',');
    List<String> options2 = list2.split(',');
    return options1.where((option) => options2.contains(option.trim())).length;
  }

}

  // Future<List<Map<String, dynamic>>> _fetchSimilarityScores() async {
  //   List<Preferences> preferences = await fetchPreferences();  // Fetch the preferences from your data source
  //   Preferences? targetUser = preferences.firstWhere((user) => user.user_id == widget.userId, orElse: () => Preferences.empty());

  //   if (targetUser.user_id == null) {
  //     throw Exception('User not found');
  //   }

  //   List<Map<String, dynamic>> similarityScores = [];
  //   for (Preferences user in preferences) {
  //     if (user.user_id != widget.userId) {
  //       SimilarityCalculator calculator = SimilarityCalculator(targetUser, user);
  //       int similarityScore = calculator.calculateSimilarity(
  //         mbtiWeight: widget.mbtiWeight,
  //         personalityWeight: widget.personalityWeight,
  //         sportWeight: widget.sportWeight,
  //         foodWeight: widget.foodWeight,
  //         fashionWeight: widget.fashionWeight,
  //         interestWeight: widget.interestWeight,
  //       );
  //       similarityScores.add({
  //         'user_id': user.user_id,
  //         'similarity_score': similarityScore,
  //       });
  //     }
  //   }

  //   similarityScores.sort((a, b) => b['similarity_score'].compareTo(a['similarity_score']));
  //   return similarityScores;
  // }



