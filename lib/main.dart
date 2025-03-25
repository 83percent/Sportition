import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportition_center/pages/clients/client_home_page.dart';
import 'package:sportition_center/pages/home_page.dart';
import 'package:sportition_center/pages/load_page.dart';
import 'package:sportition_center/pages/login/login_page.dart';
import 'package:sportition_center/pages/join_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportition',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainRedColor,
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: LoadPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/join': (context) => const JoinPage(),
        '/clients/home': (context) => const ClientHomePage(),
      },
    );
  }
}
