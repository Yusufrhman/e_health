import 'package:e_health/screen/appointment/appointment_screen.dart';
import 'package:e_health/screen/doctor/doctors_screen.dart';
import 'package:e_health/screen/home/home_screen.dart';
import 'package:e_health/screen/profile/profile_screen.dart';
import 'package:e_health/utils/config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainMenu extends ConsumerStatefulWidget {
  const MainMenu({super.key});

  @override
  ConsumerState<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends ConsumerState<MainMenu> {
  int _currentPageIndex = 0;
  List<Widget> _screens = [];
  @override
  void initState() {
    _screens = [
      HomeScreen(
        openAnotherTab: (i) {
          _currentPageIndex = i;
          setState(() {});
        },
      ),
      DoctorsScreen(),
      AppointmentScreen(),
      ProfileScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: _screens[_currentPageIndex],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Config.primaryColor.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            // gradient: const LinearGradient(
            //   colors: [Config.primaryColor, Color.fromARGB(255, 63, 226, 193)],
            // ),
            color: Config.primaryColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: NavigationBar(
          height: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          backgroundColor: const Color.fromARGB(0, 210, 8, 8),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          indicatorColor: Colors.white,
          selectedIndex: _currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home_filled,
                color: Config.primaryColor,
              ),
              icon: Icon(
                Icons.home_filled,
                color: Config.backgroundColor,
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                FontAwesomeIcons.userDoctor,
                color: Config.primaryColor,
              ),
              icon: Icon(
                FontAwesomeIcons.userDoctor,
                color: Config.backgroundColor,
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.date_range_rounded,
                color: Config.primaryColor,
              ),
              icon: Icon(
                Icons.date_range_outlined,
                color: Config.backgroundColor,
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person_2_rounded,
                color: Config.primaryColor,
              ),
              icon: Icon(
                Icons.person_2_rounded,
                color: Config.backgroundColor,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
