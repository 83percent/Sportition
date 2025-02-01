import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportition_center/pages/clients/client_home_page.dart';
import 'package:sportition_center/pages/home_page.dart';
import 'package:sportition_center/pages/load_page.dart';
import 'package:sportition_center/pages/login_page.dart';
import 'package:sportition_center/pages/join_page.dart';
import 'package:sportition_center/services/client_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sportition_center/providers/auth_provider.dart' as local;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => local.AuthProvider()), // AuthProvider 추가
        Provider(create: (_) => ClientService()),
      ],
      child: MaterialApp(
        title: 'Sportition',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.mainRedColor, // 기본 색상을 mainRedColor로 설정
            inversePrimary: const Color(0xFFFFFFFF),
          ),
          useMaterial3: true,
        ),
        home: LoadPage(), // 초기 페이지를 LoadPage로 설정
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(), // 홈 페이지 라우트 추가
          '/join': (context) => const JoinPage(), // 회원가입 페이지 라우트 추가
          '/clients/home': (context) =>
              const ClientHomePage(), // 클라이언트 홈 페이지 라우트 추가
        },
      ),
    );
  }
}
