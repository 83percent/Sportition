import 'package:flutter/material.dart';
import 'package:sportition_center/models/clients/client_dto.dart';
import 'package:sportition_center/pages/clients/clients_detail_page.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:sportition_center/services/client/client_service.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  List<ClientDTO> _allClients = [];
  List<ClientDTO> _filteredClients = [];
  String _searchQuery = '';

  late Future<List<ClientDTO>> _clientDTOList;

  @override
  void initState() {
    super.initState();
    _clientDTOList = ClientService().getClientDTOList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    List<ClientDTO> _clientSearchDTOList =
        await ClientService().getClientDTOList();
    setState(() {
      _allClients = _clientSearchDTOList;
      _filteredClients = _clientSearchDTOList;
    });
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
    return FutureBuilder(
      future: _clientDTOList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
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
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 버튼을 오른쪽에 위치
                    children: [
                      Container(
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
                    ],
                  ),
                ),
                centerTitle: false,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // 좌우로 8만큼 패딩 추가
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
                                            uid: client.clientUID,
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
        } else {
          return const Center(child: Text('No data'));
        }
      },
    );
  }
}
