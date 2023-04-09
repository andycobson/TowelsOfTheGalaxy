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
  const AppSettingsPage(
      {super.key, required this.onPush, required this.createPush});

  final VoidCallback onPush;
  final ValueChanged<String>? createPush;

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late SharedPreferences preferences;
  late final AuthService _auth;
  String babyName = "";
  List<dynamic> babysOnFile = [];

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
        babysOnFile = currentDataUser.userBabyNames;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: babysOnFile.length,
                itemBuilder: (context, index) {
                  String babyName = babysOnFile[index].toString();
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      shape: BoxShape.circle,
                      // You can use like this way or like the below line
                      //borderRadius: new BorderRadius.circular(30.0),
                      color: ColorPalette.accent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(babyName),
                      ],
                    ),
                  );
                }),
            // ElevatedButton(
            //   onPressed: () => widget.createPush?.call(babycreateRoute),
            //   child: const Text('Create Baby'),
            // ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                shape: BoxShape.circle,
                // You can use like this way or like the below line
                //borderRadius: new BorderRadius.circular(30.0),
                color: ColorPalette.accent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => widget.createPush?.call(babycreateRoute),
                    child: const Center(
                      child: Text(
                        "+",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
