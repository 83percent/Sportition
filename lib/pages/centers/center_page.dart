import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // 클립보드 사용을 위해 추가
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:sportition_center/services/center_service.dart'; // CenterService 추가

class CenterPage extends StatefulWidget {
  const CenterPage({super.key});

  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> {
  // centerUID
  String centerUID = '';
  String centerName = ''; // 센터명 추가

  @override
  void initState() {
    super.initState();
    _loadCenterUID();
  }

  Future<void> _loadCenterUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      centerUID = prefs.getString('centerUID') ?? '';
    });
    _loadCenterName(); // 센터명 로드
  }

  Future<void> _loadCenterName() async {
    CenterService centerService = CenterService();
    String? name = await centerService.getCenterNameByUUID(centerUID);
    setState(() {
      centerName = name ?? '센터 정보';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // 뒤로가기 버튼 색상 변경
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  centerName, // 센터명 출력
                  style: const TextStyle(
                    fontFamily: 'NotoSansKR',
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.borderGray100Color,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          centerUID,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: centerUID));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('센터 UID가 복사되었습니다.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
