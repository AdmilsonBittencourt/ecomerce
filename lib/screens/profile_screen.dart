// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/edit_profile_screen.dart';
import 'package:perfumes_ecomerce/database/database_helper.dart';
import 'package:perfumes_ecomerce/models/user.dart';
import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/auth/auth_manager.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = true;
  User? _user;
  Address? _address;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authManager = Provider.of<AuthManager>(context, listen: false);
      final currentUser = authManager.currentUser;

      if (currentUser == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Usuário não está logado.';
            _isLoading = false;
          });
        }
        return;
      }

      final user = await _databaseHelper.getUser(currentUser.id!);
      if (user == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Usuário não encontrado.';
            _isLoading = false;
          });
        }
        return;
      }

      final address = await _databaseHelper.getUserAddress(currentUser.id!);

      if (mounted) {
        setState(() {
          _user = user;
          _address = address;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar dados do usuário: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editProfile() async {
    if (_user == null) return;

    final updatedUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentUser: _user!,
          currentAddress: _address,
        ),
      ),
    );

    if (updatedUser != null) {
      await _loadUserData(); // Recarrega os dados após a edição
    }
  }

  Future<void> _changePassword() async {
    // TODO: Implementar tela de alteração de senha
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  Future<void> _logout() async {
    final authManager = Provider.of<AuthManager>(context, listen: false);
    await authManager.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black12,
                        child: Icon(
                          Icons.person_outline,
                          size: 60,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        _user?.name ?? 'Nome não disponível',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        _user?.email ?? 'Email não disponível',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.email_outlined, color: Colors.black54),
                          title: const Text('Email'),
                          subtitle: Text(_user?.email ?? 'Não definido'),
                          trailing: const Icon(Icons.edit, color: Colors.black26),
                          onTap: _editProfile,
                        ),
                      ),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: Colors.black54),
                          title: const Text('Endereço'),
                          subtitle: Text(
                            _address != null
                                ? '${_address!.street}, ${_address!.number}${_address!.complement?.isNotEmpty == true ? ' - ${_address!.complement}' : ''}\n${_address!.neighborhood}, ${_address!.city} - ${_address!.state}\nCEP: ${_address!.zipCode}'
                                : 'Endereço não cadastrado',
                          ),
                          trailing: const Icon(Icons.edit, color: Colors.black26),
                          onTap: _editProfile,
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _editProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Editar Perfil',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      OutlinedButton(
                        onPressed: _changePassword,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Colors.black54),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Alterar Senha',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}