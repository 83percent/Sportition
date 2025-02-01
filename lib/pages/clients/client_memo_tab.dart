import 'package:flutter/material.dart';
import 'package:sportition_center/services/client_memo_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ClientMemoTab extends StatefulWidget {
  final String uid;

  const ClientMemoTab({Key? key, required this.uid}) : super(key: key);

  @override
  _ClientMemoTabState createState() => _ClientMemoTabState();
}

class _ClientMemoTabState extends State<ClientMemoTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _memoController = TextEditingController();
  final ClientMemoService _clientMemoService = ClientMemoService();
  bool _isMemoLoaded = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadMemo();
  }

  Future<void> _loadMemo() async {
    if (!_isMemoLoaded) {
      String? memo = await _clientMemoService.getClientMemo(widget.uid);
      if (memo != null) {
        _memoController.text = memo;
      }
      _isMemoLoaded = true;
    }
  }

  Future<void> _saveMemo() async {
    setState(() {
      _isSaving = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await _clientMemoService.saveClientMemo(widget.uid, _memoController.text);
      Navigator.of(context).pop(); // 로딩 팝업 닫기
    } catch (e) {
      Navigator.of(context).pop(); // 로딩 팝업 닫기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('오류'),
            content: const Text('메모 저장에 실패 하였습니다'),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _memoController,
              maxLines: null,
              expands: true,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: '메모를 입력하세요...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.mainRedColor,
            ),
            child: TextButton(
              onPressed: _isSaving ? null : _saveMemo,
              child: const Text(
                '저장',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
