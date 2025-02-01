import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportition_center/pages/clients/client_profile_page.dart';
import 'package:sportition_center/pages/clients/clients_detail_page.dart';
import 'package:sportition_center/pages/home/leader_board_page.dart';
import 'package:sportition_center/pages/home/settings_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // _uid가 null이 아닐 때만 MemberPage를 생성합니다.
    const ClientProfilePage(),
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
              Icons.person,
              size: _selectedIndex == 0 ? 32.0 : 25.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.leaderboard,
              size: _selectedIndex == 1 ? 32.0 : 25.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.menu,
              size: _selectedIndex == 2 ? 32.0 : 25.0,
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
