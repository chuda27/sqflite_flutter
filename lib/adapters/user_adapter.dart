import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_flutter/models/user.dart';

class UserAdapter {
  static const int _passwordIterations = 100000;

  UserAdapter._();

  static final UserAdapter instance = UserAdapter._();
  static Future<Database>? _database;

  Future<Database> get database => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final databasePath = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_fullname TEXT NOT NULL,
            user_email TEXT NOT NULL UNIQUE,
            user_password TEXT NOT NULL,
            user_birthdate TEXT NOT NULL,
            user_gender TEXT NOT NULL,
            user_address TEXT NOT NULL,
            user_phone TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final hashedPassword = await _hashPassword(user.user_password);
    final db = await database;

    return db.insert('users', {
      'user_fullname': user.user_fullname.trim(),
      'user_email': user.user_email.trim().toLowerCase(),
      'user_password': hashedPassword,
      'user_birthdate': user.user_birthdate,
      'user_gender': user.user_gender,
      'user_address': user.user_address.trim(),
      'user_phone': user.user_phone.trim(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final rows = await db.query(
      'users',
      columns: [
        'id',
        'user_fullname',
        'user_email',
        'user_birthdate',
        'user_gender',
        'user_address',
        'user_phone',
      ],
      orderBy: 'user_fullname COLLATE NOCASE',
    );
    return rows.map(User.fromMap).toList(growable: false);
  }

  Future<User?> authenticateUser({
    required String email,
    required String password,
  }) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'user_email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    final row = rows.first;
    final passwordHash = row['user_password'] as String;
    if (!await _verifyPassword(password, passwordHash)) return null;

    return User.fromMap({...row, 'user_password': ''});
  }

  Future<String> _hashPassword(String password) async {
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _passwordIterations,
      bits: 256,
    );
    final key = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final hash = await key.extractBytes();

    return [
      'pbkdf2_sha256',
      _passwordIterations.toString(),
      base64Encode(salt),
      base64Encode(hash),
    ].join(r'$');
  }

  Future<bool> _verifyPassword(String password, String encodedHash) async {
    final parts = encodedHash.split(r'$');
    if (parts.length != 4 ||
        parts[0] != 'pbkdf2_sha256' ||
        int.tryParse(parts[1]) != _passwordIterations) {
      return false;
    }

    late final List<int> salt;
    late final List<int> expectedHash;
    try {
      salt = base64Decode(parts[2]);
      expectedHash = base64Decode(parts[3]);
    } on FormatException {
      return false;
    }
    if (salt.isEmpty || expectedHash.length != 32) return false;

    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _passwordIterations,
      bits: 256,
    );
    final key = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final actualHash = await key.extractBytes();
    if (actualHash.length != expectedHash.length) return false;

    var difference = 0;
    for (var index = 0; index < actualHash.length; index++) {
      difference |= actualHash[index] ^ expectedHash[index];
    }
    return difference == 0;
  }
}
