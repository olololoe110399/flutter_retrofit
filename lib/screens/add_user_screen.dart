import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider_sample/api/rest_client.dart';
import 'package:provider_sample/models/user.dart';

class AddUserPage extends StatefulWidget {
  final User? user;

  const AddUserPage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final apiService = RestClient(Dio());
  late final TextEditingController controller;
  bool loading = false;

  @override
  void initState() {
    controller = TextEditingController(text: widget.user?.name ?? '');
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _addUser() async {
      if (controller.text.isEmpty) return;
      setState(() {
        loading = true;
      });
      await apiService.addUser(
        User(
            name: controller.text,
            createdAt: DateTime.now().toString(),
            avatar: 'https://i.pravatar.cc/150?img=${Random().nextInt(70)}'),
      );
      Navigator.pop(context);
      setState(() {
        loading = false;
      });
    }

    _updateUser() async {
      final user = widget.user!;
      if (controller.text.isEmpty) return;
      setState(() {
        loading = true;
      });
      await apiService.updateUser(
        user.id!,
        user.copyWith(
          name: controller.text,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {
        loading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User Screen'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('UserName'),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: widget.user == null ? _addUser : _updateUser,
                      child: const Text('Save'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
