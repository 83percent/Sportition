import 'package:flutter/material.dart';
import 'package:sportition_center/models/records/record_group_model.dart';
import 'package:sportition_center/services/record/client_record_service.dart';

class ClientRecordTab extends StatefulWidget {
  final String uid;

  const ClientRecordTab({Key? key, required this.uid}) : super(key: key);

  @override
  _ClientRecordTabState createState() => _ClientRecordTabState();
}

class _ClientRecordTabState extends State<ClientRecordTab> {
  List<RecordGroupModel> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    ClientRecordService clientRecordService = ClientRecordService();
    List<RecordGroupModel> records = await clientRecordService
        .getClientExerciseRecord(clientUid: widget.uid);
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
        final recordGroup = _records[index];
        return ExpansionTile(
          title: Text(recordGroup.yearMonth),
          children: recordGroup.days.map((day) {
            return ExpansionTile(
              title: Text('${day.day} Day'),
              children: day.exerciseRecords.map((exercise) {
                return ExpansionTile(
                  title: Text(exercise.exerciseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  children: exercise.records.map((record) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '무게: ${record.weight}kg',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '횟수: ${record.count}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
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
