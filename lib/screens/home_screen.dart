import 'package:flutter/material.dart';
import 'package:sqflite_flutter/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.users,
    required this.onUserSelected,
  });

  final List<User> users;
  final ValueChanged<User> onUserSelected;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const Center(child: Text('Belum ada data user.'));
    }

    return ListView.separated(
      itemCount: widget.users.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = widget.users[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              user.user_fullname.isEmpty
                  ? '?'
                  : user.user_fullname.substring(0, 1).toUpperCase(),
            ),
          ),
          title: Text(user.user_fullname),
          subtitle: Text(user.user_email),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => widget.onUserSelected(user),
        );
      },
    );
  }
}
