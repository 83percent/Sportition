import 'package:flutter/material.dart';
import 'package:sportition_center/pages/clients/clients_detail_page.dart';
import 'package:sportition_center/services/leader_board_service.dart';
import 'package:sportition_center/models/leader_borad/leader_board_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import 추가

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = '종합';
  List<LeaderBoardModel> _leaderBoardData = [];
  Map<String, dynamic>? _centerDocData;
  String _userType = ''; // userType 변수 추가

  late TabController _tabController;
  final LeaderBoardService _leaderBoardService = LeaderBoardService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategory =
            ['종합', '데드리프트', '벤치프레스', '스쿼트'][_tabController.index];
        _fetchLeaderBoardData();
      });
    });
    _loadUserType(); // userType 로드
    _fetchCenterDocData();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userType = prefs.getString('userType') ?? '';
    });
  }

  Future<void> _fetchCenterDocData() async {
    final centerDocData = await _leaderBoardService.getCenterDocData();
    setState(() {
      _centerDocData = centerDocData;
    });
    _fetchLeaderBoardData();
  }

  Future<void> _fetchLeaderBoardData() async {
    if (_centerDocData == null) {
      await _fetchCenterDocData();
      return;
    }

    List<LeaderBoardModel> data;
    switch (_selectedCategory) {
      case '스쿼트':
        data = _leaderBoardService
            .getSquatLeaderBoardListFromData(_centerDocData!);
        break;
      case '벤치프레스':
        data = _leaderBoardService
            .getBenchPressLeaderBoardListFromData(_centerDocData!);
        break;
      case '데드리프트':
        data = _leaderBoardService
            .getDeadliftLeaderBoardListFromData(_centerDocData!);
        break;
      case '종합':
      default:
        data =
            _leaderBoardService.getAllLeaderBoardListFromData(_centerDocData!);
        break;
    }

    data = data.where((item) => _getScore(item) > 0).toList();

    setState(() {
      _leaderBoardData = data;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0), // 왼쪽에 16의 패딩 설정
            child: Container(
              alignment: Alignment.centerLeft, // 가로 기준 왼쪽에 위치
              child: const Text(
                '리더보드',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          centerTitle: false, // 제목을 중앙에 배치하지 않음
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '종합'),
              Tab(text: '데드리프트'),
              Tab(text: '벤치프레스'),
              Tab(text: '스쿼트'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildLeaderBoard(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderBoard() {
    if (_leaderBoardData.isEmpty) {
      return const Center(
        child: Text(
          '기록이 아직 없습니다.',
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _leaderBoardData.length,
      itemBuilder: (context, index) {
        final item = _leaderBoardData[index];
        return Container(
          color: _getBackgroundColor(index + 1),
          child: ListTile(
            leading: SizedBox(
              width: 40,
              child: _buildRankIcon(index + 1),
            ),
            title: Text(item.name),
            trailing: Text(_getScore(item).toStringAsFixed(2),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                )),
            onTap: () {
              if (_userType == 'trainer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberPage(
                      uid: item.uid,
                      name: item.name,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  double _getScore(LeaderBoardModel record) {
    switch (_selectedCategory) {
      case '스쿼트':
        return record.squat;
      case '벤치프레스':
        return record.benchpress;
      case '데드리프트':
        return record.deadlift;
      case '종합':
      default:
        return record.all;
    }
  }

  Color _getBackgroundColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber[100]!;
      case 2:
        return Colors.grey[300]!;
      case 3:
        return Colors.brown[200]!;
      case 4:
      case 5:
      case 6:
        return Colors.grey[200]!;
      default:
        return Colors.white;
    }
  }

  Widget _buildRankIcon(int rank) {
    switch (rank) {
      case 1:
        {
          return const Icon(
            Icons.looks_one,
            color: Colors.amber,
            size: 40,
          );
        }

      case 2:
        {
          return const Icon(
            Icons.looks_two,
            color: Colors.grey,
            size: 40,
          );
        }

      case 3:
        {
          return const Icon(
            Icons.looks_3,
            color: Colors.brown,
            size: 40,
          );
        }

      case 4:
        {
          return const Icon(
            Icons.looks_4,
            color: Colors.black,
            size: 40,
          );
        }
      case 5:
        {
          return const Icon(
            Icons.looks_5,
            color: Colors.black,
            size: 40,
          );
        }

      case 6:
        {
          return const Icon(
            Icons.looks_6,
            color: Colors.black,
            size: 40,
          );
        }
      default:
        {
          return Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          );
        }
    }
  }
}
