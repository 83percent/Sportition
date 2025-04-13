import 'package:flutter/material.dart';
import 'package:sportition_center/pages/clients/client_chart_component.dart';

class ClientChartTab extends StatefulWidget {
  final String uid;
  const ClientChartTab({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _ClientCharTabState createState() => _ClientCharTabState();
}

class _ClientCharTabState extends State<ClientChartTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            // ClientChartComponent(recordName: '종합', exerciseType: 'all'),
            ClientChartComponent(
              uid: widget.uid,
              recordName: '데드리프트',
              exerciseType: 'deadlift',
            ),
            ClientChartComponent(
              uid: widget.uid,
              recordName: '벤츠프레스',
              exerciseType: 'benchpress',
            ),

            ClientChartComponent(
              uid: widget.uid,
              recordName: '스쿼트',
              exerciseType: 'squat',
            ),
          ],
        ),
      ),
    );
  }
}
