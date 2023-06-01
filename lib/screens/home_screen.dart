import 'package:flutter/material.dart';
import 'package:project_para_admin/screens/tabs/dashboard_page.dart';
import 'package:project_para_admin/screens/tabs/delivery_page.dart';
import 'package:project_para_admin/screens/tabs/drivers_page.dart';
import 'package:project_para_admin/screens/tabs/map_page.dart';
import 'package:project_para_admin/utils/colors.dart';
import 'package:project_para_admin/widgets/appbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final tabs = [
    const DashboardPage(),
    const MapPage(),
    const DriversPage(),
    const DeliveryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: tabs[_currentIndex]),
      appBar: AppbarWidget('Admin Panel'),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard_outlined,
              color: Colors.white,
            ),
            label: 'Dashboard',
            backgroundColor: grey,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map_outlined,
                color: Colors.white,
              ),
              backgroundColor: grey,
              label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book_online,
                color: Colors.white,
              ),
              backgroundColor: grey,
              label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.delivery_dining_outlined,
                color: Colors.white,
              ),
              backgroundColor: grey,
              label: 'Delivery'),
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
