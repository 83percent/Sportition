import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:sportition_center/pages/join/center_info.dart';
import 'package:sportition_center/pages/join/login_info.dart';
import 'package:sportition_center/pages/join/user_info.dart';
import 'package:sportition_center/models/user/join_model.dart';
import 'package:logging/logging.dart';
import 'package:sportition_center/pages/join/user_type_info.dart';
import 'package:sportition_center/services/join_service.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  int _currentStep = 0;
  bool _isExistingCenter = false;
  final TextEditingController _centerUUIDController = TextEditingController();
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _userType = 'client';

  final JoinModel _joinModel = JoinModel(
    userType: 'client',
    email: '',
    password: '',
    name: '',
    phone: '',
  );

  static final Logger _logger = Logger('JoinPage');
  final JoinService _joinService = JoinService();

  @override
  void initState() {
    super.initState();
    _setupLogger();
  }

  void _setupLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  @override
  void dispose() {
    _centerUUIDController.dispose();
    _centerNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    _showLoading();

    try {
      await _joinService.register(_joinModel);

      _hideLoading();
      _showAlert('회원가입 되었습니다.', onConfirm: () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } catch (e) {
      print('Failed to register: $e');
      _hideLoading();
      _showAlert('회원 가입에 실패하였습니다.');
      // Rollback if necessary
      if (_joinModel.centerUUID == null && _joinModel.centerName != null) {
        QuerySnapshot centerQuery = await FirebaseFirestore.instance
            .collection('centers')
            .where('name', isEqualTo: _joinModel.centerName)
            .get();
        if (centerQuery.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('centers')
              .doc(centerQuery.docs.first.id)
              .delete();
        }
      }
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoading() {
    Navigator.of(context).pop();
  }

  void _onStepContinue() async {
    _showLoading();

    if (_currentStep == 0) {
      // 유저 타입 선택 단계
      if (_userType.isEmpty) {
        _hideLoading();
        _showAlert('유저 타입을 선택해주세요.');
        return;
      } else {
        _joinModel.userType = _userType;
      }
    } else if (_currentStep == 1) {
      if (_isExistingCenter || _userType == 'client') {
        String centerUUID = _centerUUIDController.text;
        if (centerUUID.isEmpty) {
          _hideLoading();
          _showAlert('센터 UUID를 입력해주세요.');
          return;
        }
        _joinModel.centerUUID = centerUUID;
        _joinModel.centerName = null;

        try {
          DocumentSnapshot centerDoc = await FirebaseFirestore.instance
              .collection('centers')
              .doc(_joinModel.centerUUID)
              .get();

          if (!centerDoc.exists) {
            _hideLoading();
            _showAlert('존재하지 않는 센터입니다.');
            return;
          }
        } catch (e) {
          _hideLoading();
          _showAlert('센터 확인 중 오류가 발생했습니다.');
          return;
        }
      } else {
        String centerName = _centerNameController.text;
        if (centerName.isEmpty) {
          _hideLoading();
          _showAlert('센터명을 입력해주세요.');
          return;
        }
        _joinModel.centerUUID = null;
        _joinModel.centerName = _centerNameController.text;

        try {
          QuerySnapshot centerQuery = await FirebaseFirestore.instance
              .collection('centers')
              .where('name', isEqualTo: _joinModel.centerName)
              .get();

          if (centerQuery.docs.isNotEmpty) {
            _hideLoading();
            _showAlert('이미 존재하는 센터입니다.');
            return;
          }
        } catch (e) {
          _hideLoading();
          _showAlert('센터 확인 중 오류가 발생했습니다.');
          return;
        }
      }
    } else if (_currentStep == 2) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (!_isValidEmail(email)) {
        _hideLoading();
        _showAlert('이메일 형식이 올바르지 않습니다.');
        return;
      }
      if (!_isValidPassword(password)) {
        _hideLoading();
        _showAlert('비밀번호 형식이 올바르지 않습니다.');
        return;
      }
      if (password != confirmPassword) {
        _hideLoading();
        _showAlert('비밀번호가 일치하지 않습니다.');
        return;
      }

      try {
        QuerySnapshot userQuery = await FirebaseFirestore.instance
            .collection(_userType != 'clients' ? 'trainers' : 'clients')
            .where('email', isEqualTo: email)
            .get();
        if (userQuery.docs.isNotEmpty) {
          _hideLoading();
          _showAlert('이미 가입된 사용자 입니다.');
          return;
        }
      } catch (e) {
        _hideLoading();
        _showAlert('이메일 확인 중 오류가 발생했습니다.');
        return;
      }

      _joinModel.email = email;
      _joinModel.password = password;
    } else if (_currentStep == 3) {
      String name = _nameController.text;
      String phone = _phoneController.text;

      if (!_isValidName(name)) {
        _hideLoading();
        _showAlert('이름 형식을 확인해주세요.');
        return;
      }
      if (!_isValidPhone(phone)) {
        _hideLoading();
        _showAlert('연락처 형식을 확인해주세요.');
        return;
      }

      _joinModel.name = name;
      _joinModel.phone = phone;
      _register();
      _hideLoading();
      return;
    }

    _hideLoading();
    _logger.warning('Join Model is : ${_joinModel.toJson()}');

    setState(() {
      _currentStep += 1;
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$');
    return passwordRegex.hasMatch(password);
  }

  bool _isValidName(String name) {
    return name.length >= 2 && name.length <= 10;
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^010\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  void _showAlert(String message, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
        title: const Text('회원가입'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: const Icon(Icons.check),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: details.onStepCancel,
                child: const Icon(Icons.close),
              ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text(
              '유저 타입 선택',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.baseBlack,
              ),
            ),
            content: UserTypeInfoStep(
              userType: _userType,
              onChanged: (String? value) {
                setState(() {
                  _userType = value!;
                });
              },
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text(
              '센터 정보 입력',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.baseBlack,
              ),
            ),
            content: CenterInfoStep(
              isExistingCenter: _isExistingCenter,
              centerUUIDController: _centerUUIDController,
              centerNameController: _centerNameController,
              onChanged: (bool? value) {
                setState(() {
                  _isExistingCenter = value!;
                });
              },
              userType: _userType, // 추가된 코드
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text(
              '로그인 정보 입력',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.baseBlack,
              ),
            ),
            content: LoginInfoStep(
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text(
              '회원 정보 입력',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.baseBlack,
              ),
            ),
            content: UserInfoStep(
              nameController: _nameController,
              phoneController: _phoneController,
            ),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }
}
