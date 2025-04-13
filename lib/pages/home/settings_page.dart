import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportition_center/pages/centers/center_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? userType;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userType = preferences.getString('userType');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                '설정',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          centerTitle: false,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('센터 정보'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CenterPage()),
              );
            },
          ),
          if (userType == 'trainer') const Divider(),
          ListTile(
            title: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }
}
