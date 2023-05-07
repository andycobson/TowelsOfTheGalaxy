import 'dart:convert';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../constants/routes.dart';
import '../../model/app_user.dart';
import '../../model/baby_model.dart';
import '../../service/auth.dart';

class BabyCreateView extends StatefulWidget {
  const BabyCreateView({super.key});

  @override
  State<BabyCreateView> createState() => _BabyCreateViewState();
}

class _BabyCreateViewState extends State<BabyCreateView> {
  TimeOfDay time = TimeOfDay.now();
  static const List<String> list = <String>['Boy', 'Girl'];
  String dropdownValue = list.first;
  String messageText = "";
  late final TextEditingController _babyName;
  late final TextEditingController _dateOfBirth;

  late SharedPreferences preferences;
  late final DatabaseService _service;
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _babyName = TextEditingController();
    _dateOfBirth = TextEditingController();
    _auth = AuthService();
    _service = DatabaseService();

    initPerferences();
  }

  @override
  void dispose() {
    _babyName.dispose();
    _dateOfBirth.dispose();
    super.dispose();
  }

  Future initPerferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future createInstance() async {
    String babyName = _babyName.text;
    String dateOfBirth = _dateOfBirth.text;
    String gender = dropdownValue;

    // Verify Baby name is not empty
    if (babyName.isEmpty) {
      setState(() {
        messageText = "Baby name cannot be empty.";
      });
      return;
    }

    // Get the current Firebase User
    AppUser? currentUser = _auth.currentUser;
    String userId = "";
    if (currentUser != null) {
      userId = currentUser.uid;
    }

    // Check persistent data from user info
    List<dynamic> babyNames = [];

    final currentData = preferences.getString(userId);
    Map<String, dynamic> currentDataUser;
    if (currentData != null) {
      currentDataUser = json.decode(currentData);

      // Check if requested baby name is already a baby account.
      babyNames = currentDataUser['userBabyNames'];

      // Only Supports up to 5 baby
      if (babyNames.length == 5) {
        setState(() {
          messageText = "Currently we only support up to 5 baby profiles.";
        });
        return;
      }

      if (babyNames.contains(babyName)) {
        setState(() {
          messageText = "That baby name already exist for this user.";
        });
        return;
      }
    }

    // Set User Psersistence
    babyNames.add(babyName);
    PersistentUser.instance.currentBabyName = babyName;
    PersistentUser.instance.userBabyNames = babyNames;
    PersistentUser.instance.userId = userId;
    _service.updateUserState();

    final userJson = json.encode(PersistentUser.instance.toJson());
    preferences.setString(userId, userJson);

    BabyModel model = BabyModel(
        babyName: babyName,
        dateOfBirth: dateOfBirth,
        userId: userId,
        gender: gender);

    _service.createBabyUser(model);

    // Go to AppHome
    Navigator.of(context).pushNamedAndRemoveUntil(
      apphomeRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Baby Profile'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorPalette.backgroundRGB,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
          child: Column(
            children: [
              const TextDivider(text: "Name"),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 60.0, right: 60.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _babyName,
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Enter baby name',
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
              const SizedBox(
                width: 20,
              ),
              const TextDivider(text: "Birthday"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      height: 150,
                      width: 200,
                      child: Center(
                          child: TextField(
                        controller:
                            _dateOfBirth, //editing controller of this TextField
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                        ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dateOfBirth.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      ))),
                ],
              ),
              const TextDivider(text: "Gender"),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: ColorPalette.background),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                    createInstance();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
