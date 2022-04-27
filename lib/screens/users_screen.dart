import 'package:flutter/material.dart';
import 'package:provider_sample/api/rest_client.dart';
import 'package:provider_sample/models/user.dart';
import 'package:provider_sample/screens/user_detail_screen.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = RestClient(Dio());

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Screen'),
      ),
      body: FutureBuilder(
        future: apiService.getUsers(),
        builder: (context, AsyncSnapshot<List<User>?> snapshot) {
          if ((snapshot.hasError) || (!snapshot.hasData)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<User> userList = snapshot.data!;
          logger.i(userList.toString());
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
          );
        },
      ),
    );
  }
}
