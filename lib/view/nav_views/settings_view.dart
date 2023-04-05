import 'dart:convert';

import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/AppUser.dart';
import '../../model/persistentUser.dart';
import '../../service/auth.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key, required this.onPush});

  final VoidCallback onPush;

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late SharedPreferences preferences;
  late final AuthService _auth;
  String babyName = "";

  @override
  void initState() {
    super.initState();
    _auth = AuthService();

    initPerferences();
  }

  Future initPerferences() async {
    preferences = await SharedPreferences.getInstance();

    AppUser? currentUser = _auth.currentUser;
    String userId = "";
    if (currentUser != null) {
      userId = currentUser.uid;
    }

    final currentData = preferences.getString(userId);
    if (currentData != null) {
      PersistentUser currentDataUser =
          PersistentUser.fromJson(json.decode(currentData));
      setState(() {
        babyName = currentDataUser.currentBabyName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundRGB,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      backgroundColor: ColorPalette.backgroundRGB,
      body: Column(
        children: [
          Text(babyName),
          Center(
            child: ElevatedButton(
              child: const Text('Log Out'),
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                print(FirebaseAuth.instance.currentUser.toString());
                print(shouldLogout);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  widget.onPush();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
