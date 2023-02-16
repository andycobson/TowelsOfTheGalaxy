import 'package:baby_tracks/constants/routes.dart';
import 'package:baby_tracks/view/login_view.dart';
import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:baby_tracks/view/nav_views/metrics_view.dart';
import 'package:baby_tracks/view/nav_views/settings_view.dart';
import 'package:flutter/material.dart';
import '../view/nav_views/list_view.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator(
      {super.key,
      required this.navigatorKey,
      required this.tabItem,
      required this.callB});

  final String tabItem;
  final GlobalKey<NavigatorState> navigatorKey;
  final VoidCallback callB;

  void _push(BuildContext context, {String defaultRoot = appListViewRoute}) {
    var routeBuilders = _routeBuilders(context, defaultRoot: defaultRoot);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => routeBuilders[defaultRoot]!(context),
        ));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {String defaultRoot = appListViewRoute}) {
    return {
      appListViewRoute: (context) => AppListViewPage(
            onPush: (defaultRoot) => _push(context, defaultRoot: defaultRoot),
          ),
      metricsRoute: (context) => AppMetricPage(),
      settingsRoute: (context) => AppSettingsPage(
            onPush: callB,
          ),
      foodRoute: (context) => FoodView(),
      diaperRoute: (context) => DiaperView(),
      sleepRoute: (context) => SleepView(),
      loginRoute: (context) => LoginView(),
      growthRoute: (context) => GrowthView(),
      temperatureRoute: (context) => TemperatureView(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: appListViewRoute,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => routeBuilders[tabItem]!(context));
      },
    );
  }
}
