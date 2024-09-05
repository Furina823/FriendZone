import 'package:flutter/material.dart';
import 'package:friendzone_application/login_logout/login.dart';
import '../model/preferences.dart';
import '../model/user.dart';

class Preference extends StatefulWidget {
  final User user;
  const Preference({super.key, required this.user});

  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final Set<String> selectedMBTI = {};
  final Set<String> selectedPersonality = {};
  final Set<String> selectedSport = {};
  final Set<String> selectedFood = {};
  final Set<String> selectedFashion = {};
  final Set<String> selectedInterest = {};

  void _toggleSelection(
      Set<String> selectedSet, String value, int maxSelections) {
    setState(() {
      if (selectedSet.contains(value)) {
        selectedSet.remove(value);
      } else if (selectedSet.length < maxSelections) {
        selectedSet.add(value);
      }
    });
  }

  bool _isValidSelection() {
    // Ensure at least one MBTI is selected
    // Ensure at least one option is selected and at most 3 options are selected for each category
    return selectedMBTI.isNotEmpty &&
        selectedPersonality.isNotEmpty &&
        selectedPersonality.length <= 3 &&
        selectedSport.isNotEmpty &&
        selectedSport.length <= 3 &&
        selectedFood.isNotEmpty &&
        selectedFood.length <= 3 &&
        selectedFashion.isNotEmpty &&
        selectedFashion.length <= 3 &&
        selectedInterest.isNotEmpty &&
        selectedInterest.length <= 3;
  }

  Future<String?> _getIdBasedOnEmail(String email) async {
    List<User> users = await fetchUsers();

    for (User user in users) {
      if (user.email.toString() == email) {
        print("Email from database :${user.email.toString()}");
        print("User Id from database ${user.user_id.toString()}");
        return user.user_id.toString();
      }
    }

    return null;
  }

  String formatSet(Set<String> set) {
    // Convert Set to List, then join elements with commas
    // and trim any extra spaces
    return set.join(',').replaceAll(RegExp(r'\s+'), '');
  }

  void _signUp() async {
    if (_isValidSelection()) {
      // Proceed to the next page if the selections are valid
      try {
        await createUser(
          widget.user.nickname.toString(),
          (widget.user.date_of_birth != null)
              ? DateTime.parse(widget.user.date_of_birth.toString())
              : DateTime.now(),
          widget.user.gender.toString().toLowerCase(),
          widget.user.email.toString(),
          widget.user.password.toString(),
          widget.user.current_state.toString(),
          widget.user.school.toString(),
          widget.user.location.toString(),
          widget.user.language.toString(),
          widget.user.award.toString(),
          widget.user.quote.toString(),
          widget.user.profile_picture.toString(),
          DateTime.now(),
          null,
          null,
          null,
          null,
        );
      } catch (e) {
        print(e);
        String? newUserId =
            await _getIdBasedOnEmail(widget.user.email.toString());
        if (newUserId != null) {
          createPreference(
              newUserId,
              formatSet(selectedMBTI).toLowerCase(),
              formatSet(selectedPersonality).toLowerCase(),
              formatSet(selectedSport).toLowerCase(),
              formatSet(selectedFood).toLowerCase(),
              formatSet(selectedFashion).toLowerCase(),
              formatSet(selectedInterest).toLowerCase());
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      // Show an error message if the selections are not valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all required options')),
      );
    }
  }

  Widget _buildMBTISelection(
    String title,
    List<String> options,
    Set<String> selectedOptions,
    int maxSelections,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18, // Increased font size
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D9D9D), // Darker color
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8.0), // Adjusted padding
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF9D9D9D), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 3,
              mainAxisSpacing: 10,
              childAspectRatio: 3.5, // Adjust as needed
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final bool isSelected = selectedOptions.contains(option);

              return Container(
                child: ChoiceChip(
                  label: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) =>
                      _toggleSelection(selectedOptions, option, maxSelections),
                  selectedColor: const Color(0xFF4C315C),
                  backgroundColor: const Color(0xFFD9D9D9),
                  shape: const StadiumBorder(),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  showCheckmark: false,
                  side: BorderSide.none,
                  visualDensity: const VisualDensity(
                    horizontal: 1.0,
                    vertical: -4.0,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPreferenceSelection(
    String title,
    List<String> options,
    Set<String> selectedOptions,
    int maxSelections, [
    String? subtitle,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18, // Increased font size
                fontWeight: FontWeight.bold,
                color: Color(0xFF9D9D9D), // Darker color
              ),
            ),
            const SizedBox(width: 10),
            if (subtitle != null) ...[
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9D9D9D),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints(
            maxWidth: 600, // Set a max width
            minWidth: 600,
            minHeight: 80, // Set a minimum height
          ),
          padding: const EdgeInsets.all(15), // Adjusted padding
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF9D9D9D), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Wrap(
            spacing: 10.0, // Adjusted spacing
            runSpacing: 10.0, // Adjusted spacing
            children: options.map((option) {
              final bool isSelected = selectedOptions.contains(option);
              return ChoiceChip(
                label: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) =>
                    _toggleSelection(selectedOptions, option, maxSelections),
                selectedColor: const Color(0xFF4C315C),
                backgroundColor: const Color(0xFFD9D9D9),
                shape: const StadiumBorder(),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                showCheckmark: false,
                side: BorderSide.none,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                    horizontal: 4.0,
                    vertical: -2), // Optional: Make the chip more compact
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color(0xFFEEBCE3),
          ),
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'F',
                    style: TextStyle(
                      color: Color(0xFF4C315C),
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'riend',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Z',
                    style: TextStyle(
                      color: Color(0xFF4C315C),
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'one',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Itim',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 1),
              const Text(
                'Preference',
                style: TextStyle(
                    color: Color(0xFF9D9D9D),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildMBTISelection(
                'MBTI',
                [
                  'ISTJ',
                  'ISFJ',
                  'INFJ',
                  'INTJ',
                  'ISTP',
                  'ISFP',
                  'INFP',
                  'INTP',
                  'ESTP',
                  'ESFP',
                  'ENFP',
                  'ENTP',
                  'ESTJ',
                  'ESFJ',
                  'ENFJ',
                  'ENTJ'
                ],
                selectedMBTI,
                1,
              ),
              _buildPreferenceSelection(
                'Personality',
                [
                  'Adventurous',
                  'Creative',
                  'Analytical',
                  'Outgoing',
                  'Compassionate',
                  'Ambitious',
                  'Easygoing',
                  'Intellectual'
                ],
                selectedPersonality,
                3,
                "(Max 3)",
              ),
              _buildPreferenceSelection(
                'Sport',
                [
                  'Football',
                  'Basketball',
                  'Tennis',
                  'Swimming',
                  'Running',
                  'Cycling',
                  'Gym',
                  'Martial Arts'
                ],
                selectedSport,
                3,
                "(Max 3)",
              ),
              _buildPreferenceSelection(
                'Food',
                [
                  'Italian',
                  'Japanese',
                  'Mexican',
                  'Indian',
                  'Mediterranean',
                  'Chinese',
                  'Thai',
                  'Vegan'
                ],
                selectedFood,
                3,
                "(Max 3)",
              ),
              _buildPreferenceSelection(
                'Fashion',
                [
                  'Casual',
                  'Formal',
                  'Streetwear',
                  'Vintage',
                  'Bohemian',
                  'Preppy',
                  'Hip-Hop',
                  'Minimalist'
                ],
                selectedFashion,
                3,
                "(Max 3)",
              ),
              _buildPreferenceSelection(
                'Interest',
                [
                  'Movies',
                  'Music',
                  'Gaming',
                  'Books',
                  'Theater',
                  'Traveling',
                  'Cooking',
                  'Photography'
                ],
                selectedInterest,
                3,
                "(Max 3)",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59396B),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
