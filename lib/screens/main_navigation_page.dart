import 'package:flutter/material.dart';
import 'package:sqflite_flutter/adapters/user_adapter.dart';
import 'package:sqflite_flutter/models/user.dart';
import 'package:sqflite_flutter/register/register_page.dart';
import 'package:sqflite_flutter/screens/detail_screen.dart';
import 'package:sqflite_flutter/screens/home_screen.dart';
import 'package:sqflite_flutter/screens/profile_screen.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  User? _selectedUser;
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserAdapter.instance.getUsers();
  }

  Future<void> _openRegisterPage() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (context) => const RegisterPage()),
    );
    if (!mounted) return;

    setState(() {
      _usersFuture = UserAdapter.instance.getUsers();
    });
  }

  void _selectUser(User user) {
    setState(() {
      _selectedUser = user;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['Home', 'Detail', 'Profile'];

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(titles[_selectedIndex])),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data user: ${snapshot.error}'),
            );
          }

          final users = snapshot.data!;
          switch (_selectedIndex) {
            case 0:
              return HomeScreen(users: users, onUserSelected: _selectUser);
            case 1:
              return DetailScreen(
                user: _selectedUser ?? (users.isEmpty ? null : users.first),
              );
            default:
              return ProfileScreen(currentUser: widget.currentUser);
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRegisterPage,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Menambah'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
