import 'package:babytracks/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          TextField(
            //style: const TextStyle(color: Colors.white),
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here.'),
          ),
          TextField(
            //style: const TextStyle(color: Colors.white),
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here.'),
          ),
          Text(messageText,
              style: const TextStyle(
                color: Colors.red,
              )),
          /*
              Registration Button Handling
          */
          TextButton(
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
            child: const Text('Register'),
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
    );
  }
}