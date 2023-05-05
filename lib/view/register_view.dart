import 'package:baby_tracks/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/palette.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      backgroundColor: ColorPalette.backgroundRGB,
      resizeToAvoidBottomInset: true,
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
            const SizedBox(
              width: 280,
              child: Text(
                "Need a helping hand with keeping important milestones for your baby?",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPalette.offWhite,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
              width: 280,
              child: Center(
                child: Text(
                  "We got you covered! Register below!",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPalette.offWhite,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const SizedBox(
              width: 280,
              child: Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPalette.offWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                Registration Button Handling
            */
            Container(
              width: 295,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  String exceptionMessage = "";

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);

                    if (userCredential.user != null) {
                      userCredential.user?.sendEmailVerification();
                    }

                    exceptionMessage =
                        "Register Successfully! Email Veriification Sent!";
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      babycreateRoute,
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      exceptionMessage = "Password is too weak.";
                    } else if (e.code == 'email-already-in-use') {
                      exceptionMessage = ('Email already in use');
                    } else if (e.code == 'invalid-email') {
                      exceptionMessage = ('Invalid email');
                    } else {
                      exceptionMessage = (e.code);
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
                  'Register',
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
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already registered? Login here!'),
            )
          ],
        ),
      ),
    );
  }
}
