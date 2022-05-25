import 'package:flutter/material.dart';
import 'package:provider_sample/api/rest_client.dart';
import 'package:provider_sample/models/user.dart';
import 'package:provider_sample/screens/add_user_screen.dart';
import 'package:provider_sample/screens/user_detail_screen.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = RestClient(Dio());
  List<User> _users = List.empty();
  Future<void>? _initUsersData;

  @override
  void initState() {
    super.initState();
    _initUsersData = _initUsers();
  }

  Future<void> _initUsers() async {
    final users = await apiService.getUsers();
    _users = users;
  }

  Future<void> _refreshUsers() async {
    final users = await apiService.getUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    _handleNavigateUserDetail(String id) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserDetailPage(id: id),
        ),
      );
    }

    _addUser() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddUserPage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Screen'),
      ),
      body: FutureBuilder(
          future: _initUsersData,
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                List<User> userList = _users.reversed.toList();
                logger.i(userList.toString());
                return RefreshIndicator(
                  onRefresh: _refreshUsers,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    primary: false,
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userList[index].avatar ?? '',
                          ),
                        ),
                        title: Text(userList[index].name ?? ''),
                        subtitle: Text(userList[index].createdAt ?? ''),
                        onTap: () => userList[index].id != null
                            ? _handleNavigateUserDetail(
                                userList[index].id!,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
