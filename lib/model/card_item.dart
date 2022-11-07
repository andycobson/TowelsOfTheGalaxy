import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:flutter/material.dart';

class CardItem {
  String title = "";
  Color color = Colors.black;
  StatefulWidget pageview = FoodView();

  CardItem(this.title, this.color, this.pageview);

  static List<CardItem> builder() {
    return [
      CardItem('FOOD', Colors.white, FoodView()),
      CardItem('SLEEP', Colors.red, SleepView()),
      CardItem('DIAPER', Colors.blue, DiaperView())
    ];
  }
}
