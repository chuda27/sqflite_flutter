import 'package:flutter/material.dart';
import 'package:sqflite_flutter/models/user.dart';
import 'package:sqflite_flutter/screens/user_info_view.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.user});

  final User? user;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    if (user == null) {
      return const Center(
        child: Text('Belum ada data user untuk ditampilkan.'),
      );
    }

    return UserInfoView(user: user);
  }
}
