import 'package:babytracks/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Color.fromARGB(214, 3, 3, 26),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 50, left: 30.0, right: 30.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here.',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here.',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 92, 92, 94),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Text(messageText,
              style: const TextStyle(
                color: Colors.red,
              )),
          /*
              Login Button Handling
          */
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              String exceptionMessage = "";

              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  apphomeRoute,
                  (route) => false,
                );
                exceptionMessage = "Successfully Signed In";
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  exceptionMessage = "Error: User not found.";
                } else if (e.code == 'wrong-password') {
                  exceptionMessage = "Error: Wrong Password.";
                }
              }

              setState(() {
                messageText = exceptionMessage;
              });
            },
            child: const Text('Login'),
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
    );
  }
}