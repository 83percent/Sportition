import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportition_center/pages/clients/clients_detail_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:sportition_center/services/client_service.dart';
import 'package:sportition_center/models/clients/client_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  List<ClientModel> _clients = [];
  List<ClientModel> _allClients = [];
  List<ClientModel> _filteredClients = [];
  String _searchQuery = '';
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    ClientService clientService =
        Provider.of<ClientService>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('centerUID');

    if (uid != null && uid.isNotEmpty) {
      if (_isFirstLoad) {
        List<ClientModel> clients = await clientService.getClients(uid);
        prefs.setString('cachedClients', ClientModel.encode(clients));
        setState(() {
          _clients = clients;
          _allClients = clients;
          _filteredClients = clients;
          _isFirstLoad = false;
        });
      } else {
        String? cachedClients = prefs.getString('cachedClients');
        if (cachedClients != null && cachedClients.isNotEmpty) {
          List<ClientModel> clients = ClientModel.decode(cachedClients);
          setState(() {
            _clients = clients;
            _allClients = clients;
            _filteredClients = clients;
          });
        } else {
          List<ClientModel> clients = await clientService.getClients(uid);
          prefs.setString('cachedClients', ClientModel.encode(clients));
          setState(() {
            _clients = clients;
            _allClients = clients;
            _filteredClients = clients;
          });
        }
      }
    }
  }

  void _filterClients(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredClients = _allClients;
      } else {
        _filteredClients = _allClients.where((client) {
          return client.name.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                '회원',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          centerTitle: false,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0), // 좌우로 8만큼 패딩 추가
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _filterClients,
                decoration: const InputDecoration(
                  labelText: '회원명을 입력해주세요...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredClients.isEmpty
                ? const Center(
                    child: Text(
                      '아직 등록된 회원이 없어요.',
                      style: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _filteredClients.map((client) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.borderGray010Color,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ListTile(
                              title: Text(client.name,
                                  style: const TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    fontSize: 18,
                                  )),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MemberPage(
                                      uid: client.uid,
                                      name: client.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
