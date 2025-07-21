import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'models/jog_record.dart';
import 'screens/home_screen.dart';
import 'screens/plogging_diary_screen.dart';
import 'screens/trash_camera_screen.dart';
import 'screens/jogging_screen.dart';
import 'screens/community_screen.dart';

final ValueNotifier<int> tabIndexNotifier = ValueNotifier<int>(0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive 초기화
  await Hive.initFlutter();
  Hive.registerAdapter(JogRecordAdapter());
  await Hive.openBox<JogRecord>('jog_records');
  
  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    await Firebase.initializeApp();
  }
  runApp(const PloggingApp());
}

class PloggingApp extends StatelessWidget {
  const PloggingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plogging',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainTabNavigator(),
    );
  }
}

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({Key? key}) : super(key: key);
  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    PloggingDiaryScreen(),
    TrashCameraScreen(),
    JoggingScreen(),
    CommunityScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabIndexNotifier.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    tabIndexNotifier.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _selectedIndex = tabIndexNotifier.value;
    });
  }

  void _onItemTapped(int index) {
    tabIndexNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
        ],
      ),
    );
  }
}
