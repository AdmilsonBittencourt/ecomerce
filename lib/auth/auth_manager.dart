import 'package:flutter/foundation.dart';
import 'package:perfumes_ecomerce/models/user.dart';
import 'package:perfumes_ecomerce/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  User? _currentUser;
  static const String _userIdKey = 'current_user_id';

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> login(String email, String password) async {
    final user = await _databaseHelper.getUserByEmail(email);
    if (user == null) {
      throw Exception('Usuário não encontrado');
    }

    if (user.password != password) {
      throw Exception('Senha incorreta');
    }
    _currentUser = user;
    await _saveUserId(user.id!);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await _removeUserId();
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    
    if (userId != null) {
      final user = await _databaseHelper.getUser(userId);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      } else {
        await logout();
      }
    }
  }

  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<void> _removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
} 