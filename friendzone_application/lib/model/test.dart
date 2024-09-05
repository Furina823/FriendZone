import 'package:flutter/material.dart';
import '../model/user.dart';

// This is a Example to fetch user information by input user id

// void main() => runApp(App());

// class App extends StatelessWidget {
//   const App({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       home: AppHome(),
//     );
//   }
// }

// class AppHome extends StatefulWidget {
//   const AppHome({Key? key}) : super(key: key);

//   @override
//   State<AppHome> createState() => _AppHomeState();
// }

// class _AppHomeState extends State<AppHome>{
//   late User user;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch user data asynchronously when the widget initializes
//     fetchUser('31').then((fetchedUser) {
//       setState(() {
//         user = fetchedUser;
//       });
//     }).catchError((error) {
//       print('Error fetching user: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter_Api 2 Test")),
//       body: Center(
//         child: user != null ? Text("${user.nickname}") : CircularProgressIndicator(),
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
//       title: 'Flutter User List',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: UserListScreen(),
//     );
//   }
// }

// class UserListScreen extends StatefulWidget {
//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   late Future<List<User>> futureUsers;

//   @override
//   void initState() {
//     super.initState();
//     futureUsers = fetchUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: FutureBuilder<List<User>>(
//         future: futureUsers,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No users found.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 User user = snapshot.data![index];
//                 return ListTile(
//                   title: Text('${user.nickname}'),
//                   subtitle: Text('${user.email}'),
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
//   final TextEditingController _nicknameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _currentStateController = TextEditingController();
//   final TextEditingController _schoolController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _languageController = TextEditingController();
//   final TextEditingController _awardController = TextEditingController();
//   final TextEditingController _quoteController = TextEditingController();
//   final TextEditingController _profilePictureController = TextEditingController();
//   final TextEditingController _dateTimeController = TextEditingController();

//   void _submitForm() async {
//     try {
//       await createUser(
//         _nicknameController.text,
//         DateTime.now(), // Replace with actual date of birth
//         'male', // Replace with actual gender
//         _emailController.text,
//         _passwordController.text,
//         _currentStateController.text,
//         _schoolController.text,
//         _locationController.text,
//         _languageController.text,
//         _awardController.text,
//         _quoteController.text,
//         _profilePictureController.text, // Replace with actual profile picture URL
//         DateTime.now(), // Replace with actual date time
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
//                 controller: _nicknameController,
//                 decoration: InputDecoration(labelText: 'Nickname'),
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               TextFormField(
//                 controller: _currentStateController,
//                 decoration: InputDecoration(labelText: 'Current State'),
//               ),
//               TextFormField(
//                 controller: _schoolController,
//                 decoration: InputDecoration(labelText: 'School'),
//               ),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: InputDecoration(labelText: 'Location'),
//               ),
//               TextFormField(
//                 controller: _languageController,
//                 decoration: InputDecoration(labelText: 'Language'),
//               ),
//               TextFormField(
//                 controller: _awardController,
//                 decoration: InputDecoration(labelText: 'Award'),
//               ),
//               TextFormField(
//                 controller: _quoteController,
//                 decoration: InputDecoration(labelText: 'Quote'),
//               ),
//               TextFormField(
//                 controller: _profilePictureController,
//                 decoration: InputDecoration(labelText: 'Profile Picture URL'),
//               ),
//               TextFormField(
//                 controller: _dateTimeController,
//                 decoration: InputDecoration(labelText: 'Date Time'),
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
//       title: 'Update User Example',
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
//   final TextEditingController _nicknameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _currentStateController = TextEditingController();
//   final TextEditingController _schoolController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _languageController = TextEditingController();
//   final TextEditingController _awardController = TextEditingController();
//   final TextEditingController _quoteController = TextEditingController();
//   final TextEditingController _profilePictureController = TextEditingController();
//   final TextEditingController _dateTimeController = TextEditingController();

//   @override
//   void dispose() {
//     _useridController.dispose();
//     _nicknameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _currentStateController.dispose();
//     _schoolController.dispose();
//     _locationController.dispose();
//     _languageController.dispose();
//     _awardController.dispose();
//     _quoteController.dispose();
//     _profilePictureController.dispose();
//     _dateTimeController.dispose();
//     super.dispose();
//   }

//   void _submitForm() async {
//     try {
//       await updateUser(
//         _useridController.text,
//         _nicknameController.text,
//         DateTime.now(), // Replace with actual date of birth
//         'male', // Replace with actual gender
//         _emailController.text,
//         _passwordController.text,
//         _currentStateController.text,
//         _schoolController.text,
//         _locationController.text,
//         _languageController.text,
//         _awardController.text,
//         _quoteController.text,
//         _profilePictureController.text, // Replace with actual profile picture URL
//         DateTime.now(), // Replace with actual date time
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('User updated successfully!'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update user: $e'),
//         ),
//       );
//     }
//   }

//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update User'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 controller: _useridController,
//                 decoration: InputDecoration(labelText: 'User_ID'),
//               ),
//               TextFormField(
//                 controller: _nicknameController,
//                 decoration: InputDecoration(labelText: 'Nickname'),
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               TextFormField(
//                 controller: _currentStateController,
//                 decoration: InputDecoration(labelText: 'Current State'),
//               ),
//               TextFormField(
//                 controller: _schoolController,
//                 decoration: InputDecoration(labelText: 'School'),
//               ),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: InputDecoration(labelText: 'Location'),
//               ),
//               TextFormField(
//                 controller: _languageController,
//                 decoration: InputDecoration(labelText: 'Language'),
//               ),
//               TextFormField(
//                 controller: _awardController,
//                 decoration: InputDecoration(labelText: 'Award'),
//               ),
//               TextFormField(
//                 controller: _quoteController,
//                 decoration: InputDecoration(labelText: 'Quote'),
//               ),
//               TextFormField(
//                 controller: _profilePictureController,
//                 decoration: InputDecoration(labelText: 'Profile Picture URL'),
//               ),
//               TextFormField(
//                 controller: _dateTimeController,
//                 decoration: InputDecoration(labelText: 'Date Time'),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Update User'),
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
//     String userId = _controller.text;
//     try {
//       User user = await deleteUser(userId);
//       setState(() {
//         _resultMessage = 'User with ID $userId deleted successfully.';
//       });
//     } catch (e) {
//       setState(() {
//         _resultMessage = 'Failed to delete user: $e';
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
//                 labelText: 'Enter User ID to delete',
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