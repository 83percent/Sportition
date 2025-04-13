import 'package:flutter/material.dart';
import 'package:sportition_center/models/leader_borad/leader_board_dto.dart';
import 'package:sportition_center/services/leader_board/leader_board_service.dart';

class LeaderBoardListPage extends StatefulWidget {
  final String gender;
  final String type;

  const LeaderBoardListPage({
    Key? key,
    required this.gender,
    required this.type,
  }) : super(key: key);

  @override
  _LeaderBoardListPageState createState() => _LeaderBoardListPageState();
}

class _LeaderBoardListPageState extends State<LeaderBoardListPage> {
  final LeaderBoardService _leaderBoardService = LeaderBoardService();
  late Future<List<LeaderBoardDTO>> _leaderBoardFuture;

  @override
  void initState() {
    super.initState();
    _leaderBoardFuture = _leaderBoardService.getLeaderBoardList(
      widget.gender,
      widget.type,
    );
  }

  @override
  void didUpdateWidget(covariant LeaderBoardListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gender != widget.gender || oldWidget.type != widget.type) {
      setState(() {
        _leaderBoardFuture = _leaderBoardService.getLeaderBoardList(
          widget.gender,
          widget.type,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeaderBoardDTO>>(
      future: _leaderBoardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Expanded(
              child: Center(child: Text('오류 발생: ${snapshot.error}')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Expanded(child: Center(child: Text('운동 기록 정보가 없습니다.')));
        }

        final leaderBoardList = snapshot.data!;

        return Expanded(
          child: SingleChildScrollView(
            child: Column(
                children: leaderBoardList
                    .map(
                      (item) => Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 40,
                              child: Text(
                                item.rank.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              item.score.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList()),
          ),
        );
      },
    );
  }
}
