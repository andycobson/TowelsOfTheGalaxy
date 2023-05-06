import 'dart:developer';

import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/constants/routes.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/persistent_user.dart';

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
  late final DatabaseService _service;
  late String babyName;
  late List<dynamic> babysOnFile;
  late String userId;
  List<BubbleData> bubbles = [];

  @override
  void initState() {
    super.initState();
    _service = DatabaseService();

    babyName = PersistentUser.instance.currentBabyName;
    userId = PersistentUser.instance.userId;
    babysOnFile = PersistentUser.instance.userBabyNames;

    log(PersistentUser.instance.toString());

    for (var s in babysOnFile) {
      String bName = s.toString();
      bubbles.add(BubbleData(
          text: Text(bName),
          type: "text",
          func: () {
            PersistentUser.instance.currentBabyName = bName;
            _service.updateUserState();
          }));
    }
    bubbles.add(BubbleData(
        text: const Text(
          "+",
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w600,
          ),
        ),
        type: "widget",
        func: () => widget.createPush?.call(babycreateRoute)));
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
            Text(PersistentUser.instance.currentBabyName),
            Wrap(
              children: bubbles.map(
                (e) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      shape: BoxShape.circle,
                      color: ColorPalette.accent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            child: e.text,
                            onTap: () {
                              setState(e.func as VoidCallback);
                            }),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Log Out'),
                onPressed: () async {
                  final shouldLogout = await showLogOutDialog(context);
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

class BubbleData {
  Text text;
  String type;
  Function func;
  BubbleData({required this.text, required this.type, required this.func});
}
