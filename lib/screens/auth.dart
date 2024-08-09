import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TuneFlow/widgets/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isAuthenticating = false;
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  final _form = GlobalKey<FormState>(); //for form
  File? _selectedImage;

  //submitting the form
  void _submit() async {
    //currentState is a property of GlobalKey that returns the current state of the Form widget it is associated with. It can be null if the Form hasn't been initialized or is not mounted in the widget tree.
    //!: The
    ////FirebaseAuth.instance used to interact with Firebase Authentication services allows you to perform various authentication-related operations such as signing in, signing up, and managing user accounts.null assertion operator. It is used here to assert that currentState is not null. If it is null, a runtime error will occur.
    final isValid = _form.currentState!
        .validate(); //returns a boolean, true if no error popped when validating the input fields of form

    if (!isValid) {
      //if isValid is false, error message can be shown
      return; //simply return means code below this line wont be executed
    }

    //if ifValid is true then the below code will be executed
    _form.currentState!
        .save(); //save(): This method calls the onSaved callbacks for each form field, which allows you to capture the values entered into the form fields.

    try {
      //if there is no error then we are authenticating the user
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        //logging users in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _enteredUsername, password: _enteredPassword);
        //FirebaseAuth.instance used to interact with Firebase Authentication services allows you to perform various authentication-related operations such as signing in, signing up, and managing user accounts.
        //also storing usercredentials into a variable
      } else {
        //creating new users
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance.ref();
        //for every new users create a folder
        final uniqId = userCredentials.user!.uid;
        final userEmail = userCredentials.user!.email;
        final userStorage =
            storageRef.child('users').child('$uniqId').child('$userEmail.jpg');
        await userStorage.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
          ),
        );
      } else if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already in use'),
          ),
        );
      } else if (error.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network Error'),
          ),
        );
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Password'),
          ),
        );
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  //picking an image
                  if (!_isLogin)
                    UserImagePicker(
                      onPickedImage: (pickedImage) {
                        _selectedImage = pickedImage;
                      },
                    ),
                  //inputting email from user
                  if (!_isLogin)
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'email'),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                  const SizedBox(height: 16),
                  //inputting email from user
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length < 4) {
                        return 'Please enter atleast 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredUsername = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  //inputting password from user
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'password'),
                    obscureText: true, //hides the characters
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length < 6) {
                        return 'Password must be atleast six characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredPassword = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_isAuthenticating) const CircularProgressIndicator(),
                  if (!_isAuthenticating)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      onPressed: _submit,
                      //if logging in then label will be login or else signup
                      child: Text(_isLogin ? "LogIn" : "SignUp"),
                    ),
                  if (!_isAuthenticating)
                    //when this textbutton is pressed state of islogin changes from true to false thereby call
                    //the textformfield for email also the above elevatedbutton changes from login to signup
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                          _isLogin ? "new Account" : "already have an account"),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
