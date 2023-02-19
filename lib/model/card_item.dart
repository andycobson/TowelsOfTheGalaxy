import 'package:babytracks/view/metric_views/diaper_view.dart';
import 'package:babytracks/view/metric_views/food_view.dart';
import 'package:babytracks/view/metric_views/growth_view.dart';
import 'package:babytracks/view/metric_views/sleep_view.dart';
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
      CardItem('FOOD', Colors.white, FoodView(), foodRoute),
      CardItem('SLEEP', Colors.red, SleepView(), sleepRoute),
      CardItem('DIAPER', Colors.blue, DiaperView(), diaperRoute),
      CardItem('GROWTH', Colors.orange, GrowthView(), growthRoute)
    ];
  }
}