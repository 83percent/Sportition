import 'package:flutter/material.dart';
import 'package:sportition_center/models/records/year_record_model.dart';
import 'package:sportition_center/services/client_record_service.dart';
import 'package:sportition_center/shared/utils/exercise_data_util.dart';

class ClientRecordTab extends StatefulWidget {
  final String uid;

  const ClientRecordTab({Key? key, required this.uid}) : super(key: key);

  @override
  _ClientRecordTabState createState() => _ClientRecordTabState();
}

class _ClientRecordTabState extends State<ClientRecordTab> {
  List<YearRecordModel> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    ClientRecordService clientRecordService =
        ClientRecordService(uid: widget.uid);
    List<YearRecordModel> records =
        await clientRecordService.getClientExerciseRecord();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, index) {
        YearRecordModel yearRecord = _records[index];
        return ExpansionTile(
          title: Row(
            children: [
              Text(
                yearRecord.year,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                ' 년',
                style: TextStyle(
                  fontFamily: 'Notosans',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          children: yearRecord.monthRecords.map((monthRecord) {
            return ExpansionTile(
              backgroundColor: Colors.grey[50],
              title: Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    monthRecord.month,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    ' 월',
                    style: TextStyle(
                      fontFamily: 'Notosans',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              children: monthRecord.dayRecords.map((dayRecord) {
                return ExpansionTile(
                  backgroundColor: Colors.grey[100],
                  title: Row(
                    children: [
                      const SizedBox(width: 32),
                      Text(
                        dayRecord.day,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        ' 일',
                        style: TextStyle(
                          fontFamily: 'Notosans',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  children: dayRecord.exerciseRecords.map((exerciseRecord) {
                    return FutureBuilder<String?>(
                      future: ExerciseDataUtil()
                          .getExerciseName(exerciseRecord.value),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return ListTile(
                          title: Center(
                            child: Text(snapshot.data ?? 'Unknown Exercise',
                                style: const TextStyle(
                                  fontFamily: 'Notosans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: exerciseRecord.records.map(
                              (detail) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                detail.weight.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Text(
                                                ' kg',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                detail.count.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Text(
                                                ' 회',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}
