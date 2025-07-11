import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'jogging_screen.dart';
import 'trash_camera_screen.dart';
import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    const DashboardScreen(),
    const JoggingScreen(),
    const TrashCameraScreen(),
    const CommunityScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '대시보드'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: '조깅'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '쓰레기'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
} 