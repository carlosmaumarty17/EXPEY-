import 'dart:convert';
import 'package:sentir/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static const _userKey = 'current_user';
  final _uuid = const Uuid();

  Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      try {
        return User.fromJson(json.decode(userJson) as Map<String, dynamic>);
      } catch (e) {
        return _createDefaultUser();
      }
    }
    
    return _createDefaultUser();
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> updateUser(User user) async {
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    await saveUser(updatedUser);
  }

  User _createDefaultUser() {
    final now = DateTime.now();
    return User(
      id: _uuid.v4(),
      name: 'Usuario',
      email: 'usuario@expeya.com',
      createdAt: now,
      updatedAt: now,
    );
  }
}
