import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popover/popover.dart';
import '../model/review.dart';
import '../model/friend.dart';

class MyButton extends StatelessWidget {
  final String userId;
  final String ownId;

  const MyButton({super.key, required this.userId, required this.ownId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        bodyBuilder: (context) => MenuItems(
          userId: userId,
          ownId: ownId,
        ),
        width: 100,
        height: 80,
        backgroundColor: Colors.deepPurple.shade300,
      ),
      child: const Icon(Icons.more_vert),
    );
  }
}

class MenuItems extends StatelessWidget {
  final String userId;
  final String ownId;

  const MenuItems({super.key, required this.userId, required this.ownId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: FontAwesomeIcons.circleExclamation,
          color: Colors.red,
          label: "Report",
          onTap: () => _showReportDialog(context, userId),
        ),
        _buildMenuItem(
          context,
          icon: FontAwesomeIcons.ban,
          color: Colors.red,
          label: "Block",
          onTap: () => _showBanDialog(context, userId, ownId),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required Color color,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 40,
        width: 100,
        color: const Color.fromARGB(255, 217, 217, 217),
        child: Row(
          children: [
            FaIcon(icon, size: 20, color: color),
            Text("  $label", style: TextStyle(color: color, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void _showReportDialog(BuildContext context, String userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportDialog(userId: userId);
    },
  );
}

class ReportDialog extends StatelessWidget {
  final String userId;

  const ReportDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffD9D9D9),
      title: const Text(
        "Confirm Report",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xff4C315C),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      content: const Text(
        "You are about to report this user for violating our community guidelines. Please confirm your action.",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel",
              style: TextStyle(color: Color(0xff4C315C), fontSize: 16)),
        ),
        TextButton(
          onPressed: () async {
            try {
              // Call createReview and wait for it to complete
              await createReview(userId, null);
              Navigator.pop(context); // Close the initial dialog

              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xffD9D9D9),
                    title: const Text(
                      "Report Success",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xff4C315C),
                      ),
                    ),
                    content: const Text(
                      "Your report has been successfully submitted.",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              // Handle error if needed
              print('Error creating review: $e');
              // Optionally show an error dialog
            }
          },
          child: const Text("Report",
              style: TextStyle(color: Colors.red, fontSize: 16)),
        ),
      ],
    );
  }
}

void _showBanDialog(BuildContext context, String userId, String ownId) {
  String userId1 = userId;
  String ownId1 = ownId;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BanDialog(
        userId: userId1,
        ownId: ownId1,
      );
    },
  );
}

class BanDialog extends StatelessWidget {
  final String ownId;
  final String userId;

  const BanDialog({super.key, required this.ownId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffD9D9D9),
      title: const Text(
        "Are you sure you want to block this user?",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xff4C315C),
        ),
      ),
      content: const Text(
        'By clicking "Confirm", you acknowledge that this action can be undone from your blocked users list but will immediately take effect.',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            try {
              deleteRelationship(ownId, userId);
              Navigator.pop(context); // Close the initial dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xffD9D9D9),
                    title: const Text("Block Success", style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xff4C315C),
                            ),),
                    content: const Text("You have blocked this user.", style: TextStyle(fontWeight: FontWeight.w600),),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the success dialog
                          Navigator.of(context).popUntil((route) =>
                              route.isFirst); // Navigate back to the home page
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              print("Error blocking user: $e");
              // Optional: Show an error dialog or a Snackbar to notify the user about the issue
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xffD9D9D9),
                    title: const Text("Error",  style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xff4C315C),
                            ),),
                    content: Text(
                        "Failed to block the user. Please try again later. Error: $e", style: TextStyle(fontWeight: FontWeight.w600),),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text("Block",
              style: TextStyle(color: Colors.red, fontSize: 16)),
        ),
      ],
    );
  }
}

void deleteRelationship(String ownId, String otherId) async {
  try {
    // Fetch all friends
    List<Friend> futureFriends = await fetchFriends();

    // Filter friends to find the matching pairs
    List<Friend> filteredFriends = futureFriends.where((friend) {
      return (friend.user_id.toString() == ownId &&
              friend.user_id_2.toString() == otherId) ||
          (friend.user_id.toString() == otherId &&
              friend.user_id_2.toString() == ownId);
    }).toList();

    // Check if we have exactly two friends to delete
    if (filteredFriends.length == 2) {
      // Check if the two filtered friends are the same pair but in different orders
      bool isValidPair =
          (filteredFriends[0].user_id == filteredFriends[1].user_id_2 &&
              filteredFriends[0].user_id_2 == filteredFriends[1].user_id);

      if (isValidPair) {
        // Delete both friends
        await deleteFriend(filteredFriends[0].friend_id.toString());
        await deleteFriend(filteredFriends[1].friend_id.toString());
      } else {
        print('Filtered friends do not match expected pair.');
      }
    } else {
      print('Invalid number of friends found: ${filteredFriends.length}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
