import 'package:baby_tracks/constants/routes.dart';
import 'package:baby_tracks/view/login_view.dart';
import 'package:baby_tracks/view/metric_views/diaper_view.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:baby_tracks/view/metric_views/throwup_view.dart';
import 'package:baby_tracks/view/metric_views/medicine_view.dart';
import 'package:baby_tracks/view/nav_views/metrics_view.dart';
import 'package:baby_tracks/view/nav_views/settings_view.dart';
import 'package:baby_tracks/view/nav_views/babycreate_view.dart';
import 'package:flutter/material.dart';
import '../view/entries_views/analytics_view.dart';
import 'package:optional/optional.dart';
import '../view/entries_views/customer_filter_view.dart';
import '../view/entries_views/weeks_entrys_view.dart';
import '../view/entries_views/todays_entrys_view.dart';
import '../view/metric_views/vaccine_view.dart';
import '../view/nav_views/list_view.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator(
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
      metricsRoute: (context) => AppMetricPage(
            onPush: (defaultRoot) => _push(context, defaultRoot: defaultRoot),
          ),
      settingsRoute: (context) => AppSettingsPage(
            onPush: callB,
            createPush: (defaultRoot) =>
                _push(context, defaultRoot: defaultRoot),
          ),
      foodRoute: (context) => FoodView(const Optional.empty()),
      diaperRoute: (context) => DiaperView(const Optional.empty()),
      sleepRoute: (context) => SleepView(const Optional.empty()),
      loginRoute: (context) => const LoginView(),
      growthRoute: (context) => GrowthView(const Optional.empty()),
      temperatureRoute: (context) => TemperatureView(const Optional.empty()),
      throwupRoute: (context) => ThrowUpView(const Optional.empty()),
      vaccineRoute: (context) => VaccineView(const Optional.empty()),
      dayRoute: (context) => const DaysView(),
      weekRoute: (context) => const WeeksView(),
      customRoute: (context) => const CustomView(),
      babycreateRoute: (context) => const BabyCreateView(),
      analyticsRoute: (context) => const AnalyticsView(),
      medicineRoute: (context) => MedicineView(const Optional.empty()),
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
