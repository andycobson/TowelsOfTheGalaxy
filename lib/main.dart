import 'package:baby_tracks/view/app_home.dart';
import 'package:baby_tracks/view/loading_view.dart';
import 'package:baby_tracks/view/register_view.dart';
import 'package:baby_tracks/view/login_view.dart';
import 'package:baby_tracks/view/verify_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        apphomeRoute: (context) => const AppHomePage(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SharedPreferences preferences;

  Future init() async {
    preferences = await SharedPreferences.getInstance();

    String? userState = preferences.getString('userId');
    if (userState == null) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: FutureBuilder(
          future: Future.wait([
            init(),
            Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            )
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return const LoginView();
                }
                return const AppHomePage();
              default:
                return const LoadingPage();
              //   if (user != null) {
              //     if (user.emailVerified) {
              //       print('Email is verified.');
              //     } else {
              //       return const VerifyEmailView();
              //     }
              //   } else {
              //     return const LoginView();
              //   }
              //   return const AppHomePage();
              // default:
              //   return const LoadingPage();
            }
          }),
    );
  }
}
