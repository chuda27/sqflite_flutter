import 'package:flutter/material.dart';
import 'package:sqflite_flutter/models/user.dart';

class UserInfoView extends StatelessWidget {
  const UserInfoView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final initials = user.user_fullname.isEmpty
        ? '?'
        : user.user_fullname.substring(0, 1).toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            child: Text(
              initials,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.user_fullname,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          _UserInfoRow(label: 'Email', value: user.user_email),
          _UserInfoRow(label: 'Tanggal lahir', value: user.user_birthdate),
          _UserInfoRow(label: 'Jenis kelamin', value: user.user_gender),
          _UserInfoRow(label: 'Alamat', value: user.user_address),
          _UserInfoRow(label: 'Nomor telepon', value: user.user_phone),
        ],
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  const _UserInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(label), subtitle: Text(value)),
    );
  }
}
