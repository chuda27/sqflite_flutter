import 'package:flutter/material.dart';
import 'package:sqflite_flutter/models/user.dart';
import 'package:sqflite_flutter/screens/user_info_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return UserInfoView(user: widget.currentUser);
  }
}
