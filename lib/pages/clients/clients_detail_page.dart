import 'package:flutter/material.dart';
import 'package:sportition_center/pages/clients/client_chart_tab.dart';
import 'package:sportition_center/pages/exercise/exercise_record/exercise_record_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'client_record_tab.dart';
import 'client_memo_tab.dart';

class MemberPage extends StatefulWidget {
  final String uid;
  final String name;

  const MemberPage({
    Key? key,
    required this.uid,
    required this.name,
  }) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isClientRecordTabLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 탭의 길이를 2로 변경
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToExerciseRecordPage() {
    // 운동 기록 측정 페이지로 이동하는 로직을 여기에 추가합니다.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseRecordPage(
          uid: widget.uid,
          name: widget.name,
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
        ), // 뒤로가기 버튼 색상 변경
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 추가
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 추가
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                  ),
                ),
                Text(
                  widget.uid,
                  style: const TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 14,
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
              Tab(text: '성장 그래프'),
              Tab(text: '일별 운동 기록'),
              Tab(text: '메모'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ClientChartTab(uid: widget.uid),
                _isClientRecordTabLoaded
                    ? ClientRecordTab(uid: widget.uid)
                    : FutureBuilder<void>(
                        future: Future.delayed(
                          Duration.zero,
                          () {
                            setState(
                              () {
                                _isClientRecordTabLoaded = true;
                              },
                            );
                          },
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ClientRecordTab(uid: widget.uid);
                        },
                      ),
                ClientMemoTab(uid: widget.uid),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToExerciseRecordPage,
        backgroundColor: AppColors.mainRedColor,
        child: const Icon(
          Icons.fitness_center,
          color: Colors.white,
        ),
      ),
    );
  }
}
