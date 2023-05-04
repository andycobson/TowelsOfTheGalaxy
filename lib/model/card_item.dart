import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:baby_tracks/view/metric_views/throwup_view.dart';
import 'package:baby_tracks/view/metric_views/vaccine_view.dart';
import 'package:baby_tracks/view/metric_views/medicine_view.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import '../constants/routes.dart';
import '../view/entries_views/Analytics.dart';
import '../view/entries_views/CustomFilter.dart';
import '../view/entries_views/PastSvnDays.dart';
import '../view/entries_views/TodaysEntrys.dart';

class CardItem {
  String title = "";
  Color color = Colors.black;
  StatefulWidget pageview = FoodView(const Optional.empty());
  String route = "";

  CardItem(this.title, this.color, this.pageview, this.route);

  static List<CardItem> builder() {
    return [
      CardItem('FOOD', const Color.fromARGB(255, 231, 255, 172),
          FoodView(const Optional.empty()), foodRoute),
      CardItem('SLEEP', const Color.fromARGB(255, 137, 207, 240),
          SleepView(const Optional.empty()), sleepRoute),
      CardItem('DIAPER', const Color.fromARGB(255, 182, 225, 80),
          DiaperView(const Optional.empty()), diaperRoute),
      CardItem('GROWTH', Colors.orange, GrowthView(const Optional.empty()),
          growthRoute),
      CardItem('TEMPERATURE', Colors.deepPurpleAccent,
          TemperatureView(const Optional.empty()), temperatureRoute),
      CardItem('THROWUP', Color.fromARGB(255, 232, 132, 255),
          ThrowUpView(const Optional.empty()), throwupRoute),
      CardItem('VACCINE', Color.fromARGB(255, 12, 176, 141),
          VaccineView(const Optional.empty()), vaccineRoute),
      CardItem('MEDICINE', Color.fromARGB(200, 0, 200, 10),
          MedicineView(const Optional.empty()), medicineRoute),
    ];
  }
}

class CardItemB {
  String title = "";
  Color color = Colors.black;
  StatefulWidget pageview = DaysView();
  String route = "";

  CardItemB(this.title, this.color, this.pageview, this.route);

  static List<CardItemB> builder() {
    return [
      CardItemB('TODAYS ENTRIES', const Color.fromARGB(255, 231, 255, 172),
          DaysView(), dayRoute),
      CardItemB('THIS WEEKS ENTRIES', const Color.fromARGB(255, 137, 207, 240),
          WeeksView(), weekRoute),
      CardItemB('CUSTOM FILTER ENTRIES',
          const Color.fromARGB(255, 182, 225, 80), CustomView(), customRoute),
      CardItemB('ANALYTICS', const Color.fromARGB(255, 182, 225, 80),
          AnalyticsView(), analyticsRoute),
    ];
  }
}
