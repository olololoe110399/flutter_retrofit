import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:provider_sample/api/rest_client.dart';
import 'package:provider_sample/models/user.dart';

final logger = Logger();

class UserDetailPage extends StatefulWidget {
  final String id;
  const UserDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final apiService = RestClient(Dio());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Detail Screen'),
      ),
      body: FutureBuilder(
        future: apiService.getUserDetail(widget.id),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if ((snapshot.hasError) || (!snapshot.hasData)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = snapshot.data!;
          logger.i(user.toJson());
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  child: ClipOval(
                    child: Image.network(
                      user.avatar ?? '',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    children: [
                      _buildItem(
                        Icons.cast_connected,
                        user.id,
                      ),
                      _buildItem(
                        Icons.account_circle_outlined,
                        user.name,
                      ),
                      _buildItem(
                        Icons.date_range,
                        user.createdAt,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(IconData icon, String? title) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF5F6F9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title ?? "",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      );
}
