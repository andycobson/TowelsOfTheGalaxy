import 'dart:convert';

import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/persistent_user.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String messageText = "";

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorPalette.backgroundRGB,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 124.0,
            ),
            const Text(
              "Baby Tracks",
              style: TextStyle(
                fontSize: 42,
                color: ColorPalette.lightAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            const Text(
              "Welcome parents to your other little helper.",
              style: TextStyle(
                color: ColorPalette.offWhite,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 25),
            const SizedBox(
              width: 280,
              child: Text(
                "Sign In",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPalette.offWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const SizedBox(
              width: 280,
              child: Text(
                "Email",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ColorPalette.offWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 60.0, right: 60.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  hintStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 280,
              child: Text(
                "Password",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ColorPalette.offWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 60.0, right: 60.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              messageText,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            /*
                Login Button Handling
            */
            SizedBox(
              width: 295,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  String exceptionMessage = "";

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (PersistentUser.instance.currentBabyName == "") {
                      final String? userId =
                          FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                        String? userState = preferences.getString(userId);

                        if (userState == null) {
                          exceptionMessage = "something went wrong";
                        } else {
                          Map<String, dynamic> jsonInfo =
                              json.decode(userState);
                          PersistentUser(jsonInfo['currentBabyName'], userId,
                              jsonInfo['userBabyNames']);
                        }
                      }
                    }

                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        apphomeRoute,
                        (route) => false,
                      );
                    }
                    exceptionMessage = "Successfully Signed In";
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found' ||
                        e.code == 'wrong-password') {
                      exceptionMessage =
                          "The Email and/or Password was not found.";
                    }
                  }

                  setState(() {
                    messageText = exceptionMessage;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      ColorPalette.lightAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: ColorPalette.backgroundRGB,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register here!'),
            )
          ],
        ),
      ),
    );
  }
}
