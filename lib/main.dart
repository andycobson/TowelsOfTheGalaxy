import 'package:baby_tracks/view/app_home.dart';
import 'package:baby_tracks/view/loading_view.dart';
import 'package:baby_tracks/view/register_view.dart';
import 'package:baby_tracks/view/login_view.dart';
import 'package:baby_tracks/view/verify_view.dart';
import 'package:flutter/material.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Tracks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        apphomeRoute: (context) => const AppHomePage(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    print('Email is verified.');
                  } else {
                    return const VerifyEmailView();
                  }
                } else {
                  return const LoginView();
                }
                return const AppHomePage();
              default:
                return const LoadingPage();
            }
          }),
    );
  }
}
