import 'package:flutter/material.dart';

class LeaderBoardSelectTypeComponent extends StatefulWidget {
  final Function(String) onTypeSelected;

  const LeaderBoardSelectTypeComponent({
    Key? key,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  _LeaderBoardSelectTypeComponentState createState() =>
      _LeaderBoardSelectTypeComponentState();
}

class _LeaderBoardSelectTypeComponentState
    extends State<LeaderBoardSelectTypeComponent> {
  String selectedType = '';

  bool isActive(String type) {
    switch (type) {
      case 'all':
        return selectedType == 'all';
      case 'deadlift':
        return selectedType == 'deadlift';
      case 'benchpress':
        return selectedType == 'benchpress';
      case 'squat':
        return selectedType == 'squat';
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /* 전체 */
        Expanded(
          child: TextButton(
            onPressed: () => {
              setState(() {
                selectedType = 'all';
                widget.onTypeSelected(selectedType);
              }),
            },
            child: Text(
              '전체',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: isActive('all') ? Colors.red : Colors.grey,
                fontSize: isActive('all') ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        /* 데드리프트 */
        Expanded(
          child: TextButton(
            onPressed: () => {
              setState(() {
                selectedType = 'deadlift';
                widget.onTypeSelected(selectedType);
              }),
            },
            child: Text(
              '데드리프트',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: isActive('deadlift') ? Colors.red : Colors.grey,
                fontSize: isActive('deadlift') ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        /* 벤치프레스 */
        Expanded(
          child: TextButton(
            onPressed: () => {
              setState(() {
                selectedType = 'benchpress';
                widget.onTypeSelected(selectedType);
              }),
            },
            child: Text(
              '벤치프레스',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: isActive('benchpress') ? Colors.red : Colors.grey,
                fontSize: isActive('benchpress') ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        /* 스쿼트 */
        Expanded(
          child: TextButton(
            onPressed: () => {
              setState(() {
                selectedType = 'squat';
                widget.onTypeSelected(selectedType);
              }),
            },
            child: Text(
              '스쿼트',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: isActive('squat') ? Colors.red : Colors.grey,
                fontSize: isActive('squat') ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
