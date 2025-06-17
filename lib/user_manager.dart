import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/db/database_helper.dart';
import 'package:perfumes_ecomerce/models/user.dart';

class UserManager extends ChangeNotifier {
  UserModel? _user;
  bool isLoading = true;

  UserModel? get user => _user;

  UserManager() {
    fetchUser();
  }

  /// Busca os dados do usuário do banco e atualiza o estado.
  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();

    _user = await DatabaseHelper.instance.getUser();
    
    isLoading = false;
    notifyListeners();
  }

  /// Atualiza os dados do usuário no banco.
  Future<void> updateUser(UserModel updatedUser) async {
    await DatabaseHelper.instance.updateUser(updatedUser);
    await fetchUser(); // Após atualizar, busca os dados mais recentes.
  }
}