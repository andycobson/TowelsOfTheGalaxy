import 'package:baby_tracks/view/metric_views/babycreate_view.dart';
import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';

class CardItem {
  String title = "";
  Color color = Colors.black;
  StatefulWidget pageview = FoodView();
  String route = "";

  CardItem(this.title, this.color, this.pageview, this.route);

  static List<CardItem> builder() {
    return [
      CardItem('FOOD', const Color.fromARGB(255, 231, 255, 172), FoodView(),
          foodRoute),
      CardItem('SLEEP', const Color.fromARGB(255, 137, 207, 240), SleepView(),
          sleepRoute),
      CardItem('DIAPER', const Color.fromARGB(255, 182, 225, 80), DiaperView(),
          diaperRoute),
      CardItem('GROWTH', Colors.orange, GrowthView(), growthRoute),
      CardItem('TEMPERATURE', Colors.deepPurpleAccent, TemperatureView(),
          temperatureRoute),
      CardItem('BABY+', Colors.blue, BabyCreateView(), babycreateRoute),
    ];
  }
}
