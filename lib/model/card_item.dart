import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:baby_tracks/view/metric_views/throwup_view.dart';
import 'package:baby_tracks/view/metric_views/vaccine_view.dart';
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
      CardItem('FOOD', const Color.fromARGB(255, 231, 255, 172),
          const FoodView(), foodRoute),
      CardItem('SLEEP', const Color.fromARGB(255, 137, 207, 240),
          const SleepView(), sleepRoute),
      CardItem('DIAPER', const Color.fromARGB(255, 182, 225, 80),
          const DiaperView(), diaperRoute),
      CardItem('GROWTH', Colors.orange, const GrowthView(), growthRoute),
      CardItem('TEMPERATURE', const Color.fromARGB(129, 8, 247, 227),
          const TemperatureView(), temperatureRoute),
      CardItem('THROWUP', const Color.fromARGB(255, 173, 185, 145),
          const ThrowUpView(), throwupRoute),
      CardItem('VACCINE', const Color.fromARGB(255, 185, 176, 207),
          const VaccineView(), vaccineRoute),
    ];
  }
}
