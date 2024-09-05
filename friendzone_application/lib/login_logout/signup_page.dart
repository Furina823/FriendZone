import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';
import 'signup_page2.dart';
import 'package:intl/intl.dart';
import '../model/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String gender = 'Female';
  late Future<List<String>> futureemails;

  Future<List<String>> fetchEmails() async {

    List<User> users = await fetchUsers();
    List<String> emails = [];

    for(User user in users){
      emails.add(user.email.toString());
    }

    return emails;

  }

  @override
  void initState(){
    super.initState();
    futureemails = fetchEmails();
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  void _goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _signUp() async {
    if (await _validateInputs()) {
      try {
        bool isEmailValid = await _validateEmail(emailController.text);
        
        if (!isEmailValid) {
          // Show error if email is not valid
          return; // Exit the function if email is invalid
        }
        
        // Proceed with the rest of the sign-up process if email is valid
        DateFormat inputFormat = DateFormat('dd/MM/yy');
        DateTime dob = inputFormat.parse(dobController.text);
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage2(
            nickname: nicknameController.text,
            dob: dob,
            gender: gender,
            email: emailController.text,
            password: passwordController.text,
          )),
        );
      } catch (e) {
        _showErrorMessage('Invalid date format.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
    }
  }


  Future<bool> _validateInputs() async {
    String nickname = nicknameController.text;
    String dob = dobController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    List<String> emails = await futureemails;

    if (nickname.isEmpty) {
      _showErrorMessage('Please enter your nickname.');
      return false;
    }

    for(String s in emails){
      if(email == s){
        _showErrorMessage('Email had been registered');
        return false;
      }
    }

    if (dob.isEmpty) {
      _showErrorMessage('Please enter your date of birth.');
      return false;
    }

    if (!_validatePassword(password)) {
      _showErrorMessage('Password must be at least 8 characters long.');
      return false;
    }

    if (password != confirmPassword) {
      _showErrorMessage('Passwords do not match.');
      return false;
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _validateEmail(String email) async {
    try {
      
      // Validate email format
      RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      bool isValidFormat = emailRegExp.hasMatch(email);
      
      if (!isValidFormat) {
        _showErrorMessage('Please enter a valid email address.');
      }
      
      return isValidFormat;
    } catch (e) {
      print('Error in email validation: $e'); // Debugging info
      _showErrorMessage('Failed to validate email.');
      return false; // Ensure a boolean value is returned
    }
  }




  bool _validatePassword(String password) {
    return password.length >= 8;
  }

  void _selectGender(String selectedGender) {
    setState(() {
      gender = selectedGender;
    });
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
              RichText(
                text: TextSpan(
                  text: 'If you already have an account, ',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'log in',
                      style: const TextStyle(
                        color: Color(0xFF4C315C),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _goToLogin(context);
                        },
                    ),
                    const TextSpan(text: ' now!'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Please sign up to continue:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildLabel('Nickname'),
              const SizedBox(height: 5),
              _inputField('Input Your Nickname', nicknameController),
              const SizedBox(height: 10),
              _buildLabel('Date Of Birth'),
              const SizedBox(height: 5),
              _inputField('Input Your Date Of Birth DD/MM/YY', dobController),
              const SizedBox(height: 10),
              _buildLabel('Gender'),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectGender('Male'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: gender == 'Male'
                                ? Color(0xFF59396B)
                                : Colors.grey,
                            width: 2.0),
                        backgroundColor:
                            gender == 'Male' ? Color(0xFF59396B) : Colors.white,
                        fixedSize: const Size(double.infinity, 50),
                      ),
                      icon: Icon(
                        Icons.male,
                        color: gender == 'Male' ? Colors.white : Colors.grey,
                      ),
                      label: Text(
                        'Male',
                        style: TextStyle(
                          color: gender == 'Male' ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectGender('Female'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: gender == 'Female'
                                ? Color(0xFF59396B)
                                : Colors.grey,
                            width: 2.0),
                        backgroundColor: gender == 'Female'
                            ? Color(0xFF59396B)
                            : Colors.white,
                        fixedSize: const Size(double.infinity, 50),
                      ),
                      icon: Icon(
                        Icons.female,
                        color: gender == 'Female' ? Colors.white : Colors.grey,
                      ),
                      label: Text(
                        'Female',
                        style: TextStyle(
                          color:
                              gender == 'Female' ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildLabel('Email'),
              const SizedBox(height: 5),
              _inputField('Input Your Email', emailController),
              const SizedBox(height: 10),
              _buildLabel('Password'),
              const SizedBox(height: 5),
              _inputField(
                'Input Your Password',
                passwordController,
                isPasswordField: true,
                isPasswordVisible: isPasswordVisible,
                toggleVisibility: _togglePasswordVisibility,
              ),
              const SizedBox(height: 10),
              _buildLabel('Confirm Password'),
              const SizedBox(height: 5),
              _inputField(
                'Input to Confirm Your Password',
                confirmPasswordController,
                isPasswordField: true,
                isPasswordVisible: isConfirmPasswordVisible,
                toggleVisibility: _toggleConfirmPasswordVisibility,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59396B),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF9D9D9D),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String hintText,
    TextEditingController controller, {
    bool isPasswordField = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
    double fontSize = 16.0, // Optional parameter to set font size
    Color fontColor = Colors.grey, // Optional parameter to set font color
  }) {
    return TextField(
      controller: controller,
      obscureText: isPasswordField ? !isPasswordVisible : false,
      style: TextStyle(
        fontSize: fontSize, // Set the font size for the input text
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize, // Set the font size for the hint text
          color: fontColor.withOpacity(
              1.0), // Set the font color for the hint text (lighter)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius:
              BorderRadius.circular(20.0), // Same radius for enabled state
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF59396B), width: 2.0),
          borderRadius:
              BorderRadius.circular(20.0), // Same radius for focused state
        ),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color(0xFF9D9D9D),
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    nicknameController.dispose();
    dobController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
