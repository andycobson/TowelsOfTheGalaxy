import 'dart:convert';
import 'dart:developer';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/constants/routes.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/AppUser.dart';
import '../../model/persistentUser.dart';
import '../../service/auth.dart';
import '../../wrapperClasses/pair.dart';

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
  late final DatabaseService _service;
  late String babyName;
  late List<dynamic> babysOnFile;
  late String userId;
  List<BubbleData> bubbles = [];

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _service = DatabaseService();

    log(PersistentUser.instance.toString());

    babyName = PersistentUser.instance.currentBabyName;
    userId = PersistentUser.instance.userId;
    babysOnFile = PersistentUser.instance.userBabyNames;

    for (var s in babysOnFile) {
      String bName = s.toString();
      bubbles.add(BubbleData(
          text: Text(bName),
          type: "text",
          func: () {
            PersistentUser.instance.currentBabyName = bName;
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

  Future callSomeBodyThatYouUsedToKnow() async {
    DateTime start_Date = DateTime(
        DateTime.now().subtract(Duration(days: 18)).year,
        DateTime.now().subtract(Duration(days: 18)).month,
        DateTime.now().subtract(Duration(days: 18)).day);
    DateTime end_Date = DateTime(
        DateTime.now().add(Duration(days: 1)).year,
        DateTime.now().add(Duration(days: 1)).month,
        DateTime.now().add(Duration(days: 1)).day);
    List<Pair> some = await _service.retreiveAllAsList(
        start_Date, end_Date, "$userId#$babyName");
    log(some.toString());
  }

  Future nukeItAll() async {
    await _service.nuke("$userId#$babyName");
    log("nuked");
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
                  //String babyName = e.toString();
                  return Container(
                    margin: EdgeInsets.all(30),
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
                        InkWell(
                            child: e.text,
                            onTap: () {
                              if (e.type == "text") {
                                setState(e.func as VoidCallback);
                              } else {
                                e.func;
                              }
                            }),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
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
            SizedBox(
              height: 50,
              width: 425,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
                onPressed: () async {
                  callSomeBodyThatYouUsedToKnow();
                },
                child: const Text('Get it all'),
              ),
            ),
            SizedBox(
              height: 50,
              width: 425,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
                onPressed: () async {
                  nukeItAll();
                },
                child: const Text('Nuke'),
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
