import 'package:flutter/material.dart';
import 'package:sportition_center/services/login_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadPage extends StatefulWidget {
  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptAutoLogin();
    });
  }

  void _attemptAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? centerUID = prefs.getString('centerUID');

    if (centerUID != null) {
      LoginService.autoLogin(context);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'SPORTITION',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.mainRedColor,
          ),
        ),
      ),
    );
  }
}
