import 'package:flutter/material.dart';

abstract class MetricInterface {
  Map<String, dynamic> toJson();
  Widget analyticsWidget();
  Future routeToEdit(dynamic context, String id);
  String getCollectionName();
}
