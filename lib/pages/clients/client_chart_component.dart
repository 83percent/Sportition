import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportition_center/models/records/chart/main_record_dto.dart';
import 'package:sportition_center/services/record/main_records_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:intl/intl.dart';

class ClientChartComponent extends StatefulWidget {
  final String uid;
  final String recordName;
  final String exerciseType;

  ClientChartComponent({
    Key? key,
    required this.uid,
    required this.recordName,
    required this.exerciseType,
  }) : super(key: key);

  @override
  _ClientChartComponentState createState() => _ClientChartComponentState();
}

class _ClientChartComponentState extends State<ClientChartComponent> {
  late Future<List<MainRecordDTO>> _recordListFuture;

  @override
  void initState() {
    super.initState();
    _recordListFuture = MainRecordsService().getMainRecordListByExerciseType(
      uid: widget.uid,
      exerciseType: widget.exerciseType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.recordName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: FutureBuilder<List<MainRecordDTO>>(
              future: _recordListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<MainRecordDTO> records = snapshot.data!;
                  // 데이터 검증 및 유효한 데이터만 사용
                  final validSpots = records
                      .map((record) {
                        try {
                          DateTime date =
                              DateFormat('MM-dd').parse(record.date);
                          double weight = double.parse(record.weight);
                          if (weight.isFinite) {
                            return FlSpot(
                              date.millisecondsSinceEpoch.toDouble(),
                              weight,
                            );
                          }
                        } catch (_) {
                          // 무시하고 유효하지 않은 데이터는 제외
                        }
                        return null;
                      })
                      .where((spot) => spot != null)
                      .cast<FlSpot>()
                      .toList();

                  return LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: validSpots,
                          isCurved: false,
                          colors: [AppColors.mainRedColor],
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            colors: [
                              AppColors.mainRedColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        topTitles: SideTitles(
                          showTitles: false,
                        ),
                        rightTitles: SideTitles(
                          showTitles: true,
                        ),
                        leftTitles: SideTitles(
                          showTitles: false,
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt());
                            return '${date.month}/${date.day}';
                          },
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      gridData: FlGridData(show: true, drawVerticalLine: true),
                    ),
                  );
                } else {
                  return const Center(child: Text('운동 데이터가 아직 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
