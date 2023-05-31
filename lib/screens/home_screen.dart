import 'package:flutter/material.dart';
import 'package:project_para_admin/screens/tabs/dashboard_page.dart';
import 'package:project_para_admin/screens/tabs/drivers_page.dart';
import 'package:project_para_admin/screens/tabs/map_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final tabs = [const DashboardPage(), const MapPage(), const DriversPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
            backgroundColor: Colors.green[900],
          ),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.green[900],
              label: 'Add Product'),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.message,
                color: Colors.white,
              ),
              backgroundColor: Colors.green[900],
              label: 'Messages'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
