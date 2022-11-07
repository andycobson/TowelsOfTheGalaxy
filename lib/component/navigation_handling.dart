import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/nav_views/metrics_view.dart';
import 'package:baby_tracks/view/nav_views/settings_view.dart';
import 'package:flutter/material.dart';
import '../view/nav_views/list_view.dart';

class TabNavigatorRoutes {
  static const String root = 'Home';
  static const String page2 = 'Metrics';
  static const String page3 = 'Settings';
  static const String food = 'FOOD';
  static const String diaper = 'DIAPER';
  static const String sleep = 'SLEEP';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({super.key, required this.navigatorKey, required this.tabItem});

  final String tabItem;
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, {String defaultRoot = "Home"}) {
    var routeBuilders = _routeBuilders(context, defaultRoot: defaultRoot);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => routeBuilders[defaultRoot]!(context),
        ));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {String defaultRoot = "Home"}) {
    return {
      TabNavigatorRoutes.root: (context) => AppListViewPage(
            onPush: (defaultRoot) => _push(context, defaultRoot: defaultRoot),
          ),
      TabNavigatorRoutes.page2: (context) => AppMetricPage(),
      TabNavigatorRoutes.page3: (context) => AppSettingsPage(),
      TabNavigatorRoutes.food: (context) => FoodView(),
      TabNavigatorRoutes.diaper: (context) => DiaperView(),
      TabNavigatorRoutes.sleep: (context) => SleepView()
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => routeBuilders[tabItem]!(context));
      },
    );
  }
}
