import 'package:flutter/material.dart';
import '/model/review.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This is a Example to fetch user information by input user id

// void main() => runApp(App());

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AppHome(),
//     );
//   }
// }


// class AppHome extends StatefulWidget {
//   const AppHome({super.key});

//   @override
//   State<AppHome> createState() => _AppHomeState();
// }


// class _AppHomeState extends State<AppHome> {
//   late Future<Review> futureReview;

//   @override
//   void initState(){
//     super.initState();
//     futureReview = fetchReview(6);
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter_Api 2 Test"),),
//       body: Center(
//         child: FutureBuilder<Review>(
//           future: futureReview,
//           builder: (context, snapshot){
//             if(snapshot.hasData){
//               return Column(
//                 children: [
//                   Text("${snapshot.data!.review_id}"),
//                   Text("${snapshot.data!.user_id}"),
//                   Text("${snapshot.data!.post_id}"),
//                 ],
//               );
//             }else if(snapshot.hasError){
//               return Text("${snapshot.error}");
//             }
//             return const CircularProgressIndicator();
//           },
//         )
//       ),
//     );
//   }
// }


//  * * * Example to get all User information

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Review List',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ReviewListScreen(),
//     );
//   }
// }

// class ReviewListScreen extends StatefulWidget {
//   @override
//   _ReviewListScreenState createState() => _ReviewListScreenState();
// }

// class _ReviewListScreenState extends State<ReviewListScreen> {
//   late Future<List<Review>> futureReviews;

//   @override
//   void initState() {
//     super.initState();
//     futureReviews = fetchReviews();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Review List'),
//       ),
//       body: FutureBuilder<List<Review>>(
//         future: futureReviews,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No Reviews found.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 Review review = snapshot.data![index];
//                 return ListTile(
//                   title: Text('${review.review_id}'),
//                   subtitle: Text('${review.user_id}'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }


// Add user record example
// This stuff will actually display Error even the recorded is added in Database
// idw to deal with this anymore

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Create User Example',
//       home: CreateUserPage(),
//     );
//   }
// }

// class CreateUserPage extends StatefulWidget {
//   @override
//   _CreateUserPageState createState() => _CreateUserPageState();
// }

// class _CreateUserPageState extends State<CreateUserPage> {
//   final TextEditingController _useridController = TextEditingController();
//   final TextEditingController _postidController = TextEditingController();

//   void _submitForm() async {
//     try {
//       await createReview(
//         _useridController.text,
//         _postidController.text
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('User created successfully!'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to create user: $e'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create User'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 controller: _useridController,
//                 decoration: InputDecoration(labelText: 'user_id'),
//               ),
//               TextFormField(
//                 controller: _postidController,
//                 decoration: InputDecoration(labelText: 'post_id'),
//               ),
              
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Create User'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// Demo for Update User Information
// well, same as add record, it jump error notification but database changed
// ( can just not show that notification ? XD )

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Update Review Example',
//       home: CreateReviewPage(),
//     );
//   }
// }

// class CreateReviewPage extends StatefulWidget {
//   @override
//   _CreateReviewPageState createState() => _CreateReviewPageState();
// }

// class _CreateReviewPageState extends State<CreateReviewPage> {
//   final TextEditingController _reviewidController = TextEditingController();
//   final TextEditingController _useridController = TextEditingController();
//   final TextEditingController _postidController = TextEditingController();

//   @override
//   void dispose() {
//     _reviewidController.dispose();
//     _reviewidController.dispose();
//     _postidController.dispose();

//     super.dispose();
//   }

//   void _submitForm() async {
//     try {
//       await updateReview(
//         _reviewidController.text,
//         _useridController.text,
//         _postidController.text,// Replace with actual date of birth
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Review updated successfully!'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update Review: $e'),
//         ),
//       );
//     }
//   }

//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Review'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 controller: _reviewidController,
//                 decoration: InputDecoration(labelText: 'Review_ID'),
//               ),
//               TextFormField(
//                 controller: _useridController,
//                 decoration: InputDecoration(labelText: 'Nickname'),
//               ),
//               TextFormField(
//                 controller: _postidController,
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
              
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Update Review'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// Example for delete user

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Simple Widget',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: const SimpleWidget(),
//     );
//   }
// }

// class SimpleWidget extends StatefulWidget {
//   const SimpleWidget({super.key});

//   @override
//   _SimpleWidgetState createState() => _SimpleWidgetState();
// }

// class _SimpleWidgetState extends State<SimpleWidget> {
//   final TextEditingController _controller = TextEditingController();
//   String? _resultMessage;

//   Future<void> _handleSubmit() async {
//     String reviewId = _controller.text;
//     try {
//       Review review = await deleteReview(reviewId);
//       setState(() {
//         _resultMessage = 'Review with ID $reviewId deleted successfully.';
//       });
//     } catch (e) {
//       setState(() {
//         _resultMessage = 'Failed to delete Review: $e';
//       });
//     }
//     _controller.clear(); // Clear the input field
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Simple Widget'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _controller,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Review ID to delete',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _handleSubmit,
//               child: const Text('Submit'),
//             ),
//             const SizedBox(height: 20),
//             if (_resultMessage != null)
//               Text(
//                 _resultMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }