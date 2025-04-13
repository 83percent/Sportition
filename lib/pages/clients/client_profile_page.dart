import 'package:flutter/material.dart';
import 'package:sportition_center/pages/exercise/exercise_record/exercise_record_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import 추가
import 'client_record_tab.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({Key? key}) : super(key: key);

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isClientRecordTabLoaded = false;
  String uid = "default_uid"; // 기본 값 설정
  String name = "default_name"; // 기본 값 설정

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 1, vsync: this); // TabController length 변경
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
      }
    });
    _loadClientData(); // SharedPreferences에서 데이터 로드
  }

  Future<void> _loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid') ?? '';
      name = prefs.getString('name') ?? 'Unknown';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToExerciseRecordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseRecordPage(
          uid: uid,
          name: name,
        ),
      ),
    );
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
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: '운동 기록'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _isClientRecordTabLoaded
                    ? ClientRecordTab(uid: uid)
                    : FutureBuilder<void>(
                        future: Future.delayed(Duration.zero, () {
                          setState(() {
                            _isClientRecordTabLoaded = true;
                          });
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return ClientRecordTab(uid: uid);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
