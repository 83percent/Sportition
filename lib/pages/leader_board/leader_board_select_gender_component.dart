import 'package:flutter/material.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class LeaderBoardSelectGenderComponent extends StatefulWidget {
  final Function(String) onGenderSelected;

  const LeaderBoardSelectGenderComponent({
    Key? key,
    required this.onGenderSelected,
  }) : super(key: key);

  @override
  _LeaderBoardSelectGenderComponentState createState() =>
      _LeaderBoardSelectGenderComponentState();
}

class _LeaderBoardSelectGenderComponentState
    extends State<LeaderBoardSelectGenderComponent> {
  String seletedGender = '';

  bool isActive(String gender) {
    switch (gender) {
      case 'all':
        return seletedGender == 'all';
      case 'male':
        return seletedGender == 'male';
      case 'female':
        return seletedGender == 'female';
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
                seletedGender = 'all';
                widget.onGenderSelected(seletedGender);
              }),
            },
            child: Text(
              '전체',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: isActive('all') ? AppColors.mainRedColor : Colors.grey,
                fontSize: isActive('all') ? 18 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        /* 남자 */
        Expanded(
          child: TextButton(
            onPressed: () => {
              setState(() {
                seletedGender = 'male';
                widget.onGenderSelected(seletedGender);
              }),
            },
            child: Text(
              '남자',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: isActive('male') ? AppColors.mainRedColor : Colors.grey,
                fontSize: isActive('male') ? 18 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        /* 여자 */
        Expanded(
          child: TextButton(
            onPressed: () => {
              setState(() {
                seletedGender = 'female';
                widget.onGenderSelected(seletedGender);
              }),
            },
            child: Text(
              '여자',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color:
                    isActive('female') ? AppColors.mainRedColor : Colors.grey,
                fontSize: isActive('female') ? 18 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
