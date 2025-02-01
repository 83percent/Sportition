import 'package:flutter/material.dart';
import 'package:sportition_center/pages/home/exercise_list_page.dart';
import 'package:sportition_center/pages/home/leader_board_page.dart';
import 'package:sportition_center/pages/home/client_list_page.dart';
import 'package:sportition_center/pages/home/settings_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MemberListPage(),
    const ExerciseListPage(),
    const LeaderBoardPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.people,
              size: _selectedIndex == 0 ? 32.0 : 25.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.fitness_center,
              size: _selectedIndex == 1 ? 32.0 : 25.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.leaderboard,
              size: _selectedIndex == 2 ? 32.0 : 25.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.menu,
              size: _selectedIndex == 3 ? 32.0 : 25.0,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.mainRedColor,
        unselectedItemColor: const Color(0x30000000),
        onTap: _onItemTapped,
        selectedFontSize: 0,
      ),
    );
  }
}
