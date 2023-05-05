import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/constants/routes.dart';
import 'package:baby_tracks/view/login_view.dart';
import 'package:flutter/material.dart';

import '../component/navigation_handling.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  String _currentPage = appListViewRoute;
  List<String> pageKeys = [appListViewRoute, metricsRoute, settingsRoute];
  final Map<String, GlobalKey<NavigatorState>> _navigationKeys = {
    appListViewRoute: GlobalKey<NavigatorState>(),
    metricsRoute: GlobalKey<NavigatorState>(),
    settingsRoute: GlobalKey<NavigatorState>(),
  };

  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigationKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigationKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != appListViewRoute) {
            _selectTab(appListViewRoute, 1);

            return false;
          }
        }

        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Container(
          color: const Color.fromARGB(214, 3, 3, 26),
          child: Stack(
            children: <Widget>[
              _buildOffstageNavigator(appListViewRoute),
              _buildOffstageNavigator(metricsRoute),
              _buildOffstageNavigator(settingsRoute)
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorPalette.defaultBlue,
          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          onTap: (int index) {
            _selectTab(pageKeys[index], index);
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics), label: "Metrics"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
          navigatorKey: _navigationKeys[tabItem]!,
          tabItem: tabItem,
          callB: () => _logout()),
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginView()),
        (Route<dynamic> route) => false);
  }
}
