import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../view/entries_views/CustomFilter.dart';
import '../view/entries_views/PastSvnDays.dart';
import '../view/entries_views/TodaysEntrys.dart';
import '../view/metric_views/throwup_view.dart';
import '../view/metric_views/Vaccine_view.dart';

class CardItem {
  String title = "";
  Color color = Colors.black;
  StatefulWidget pageview = FoodView("");
  String route = "";

  CardItem(this.title, this.color, this.pageview, this.route);

  static List<CardItem> builder() {
    return [
      CardItem('FOOD', const Color.fromARGB(255, 231, 255, 172), FoodView(""),
          foodRoute),
      CardItem('SLEEP', const Color.fromARGB(255, 137, 207, 240), SleepView(""),
          sleepRoute),
      CardItem('DIAPER', const Color.fromARGB(255, 182, 225, 80), DiaperView(""),
          diaperRoute),
      CardItem('GROWTH', Colors.orange, GrowthView(""), growthRoute),
      CardItem('TEMPERATURE', Colors.deepPurpleAccent, TemperatureView(""),
          temperatureRoute),
      CardItem('THROWUP', Colors.deepPurpleAccent, ThrowUpView(""),
          throwupRoute),
      CardItem('VACCINE', Colors.deepPurpleAccent, VaccineView(""),
          vaccineRoute),
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
      CardItemB('TODAYS ENTRIES', const Color.fromARGB(255, 231, 255, 172), DaysView(),
          dayRoute),
      CardItemB('THIS WEEKS ENTRIES', const Color.fromARGB(255, 137, 207, 240), WeeksView(),
          weekRoute),
      CardItemB('CUSTOM FILTER ENTRIES', const Color.fromARGB(255, 182, 225, 80), CustomView(),
          customRoute),

    ];
    
    
  }
}




