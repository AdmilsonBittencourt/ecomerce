// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/edit_profile_screen.dart'; // Importa a tela de edição

class ProfileScreen extends StatefulWidget { // Mudado para StatefulWidget
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dados do usuário (agora mutáveis para que possamos atualizar)
  UserProfileData _userData = UserProfileData(
    name: 'João da Silva',
    email: 'joao.silva@exemplo.com',
    address: 'Rua das Flores, 123 - Cidade, Estado',
  );

  // Função para navegar para a tela de edição e aguardar o resultado
  Future<void> _editProfile() async {
    final updatedData = await Navigator.push<UserProfileData>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(currentUserData: _userData),
      ),
    );

    // Se dados foram retornados (usuário clicou em salvar)
    if (updatedData != null) {
      setState(() {
        _userData = updatedData; // Atualiza o estado da tela de perfil
      });
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Ícone/Avatar do Usuário
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

            // Nome do Usuário (agora dinâmico)
            Text(
              _userData.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Email do Usuário (agora dinâmico)
            Text(
              _userData.email,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),

            // Informações do Usuário (em cards ou list tiles)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.email_outlined, color: Colors.black54),
                title: const Text('Email'),
                subtitle: Text(_userData.email), // Usa o dado dinâmico
                trailing: const Icon(Icons.edit, color: Colors.black26),
                onTap: _editProfile, // Chama o método de edição
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
                subtitle: Text(_userData.address), // Usa o dado dinâmico
                trailing: const Icon(Icons.edit, color: Colors.black26),
                onTap: _editProfile, // Chama o método de edição
              ),
            ),
            const SizedBox(height: 32),

            // Botão de Ação "Editar Perfil"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton( // Não é mais ElevatedButton.icon, mas um ElevatedButton
                onPressed: _editProfile, // Chama o método de edição
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Alterar Senha (em breve!)')),
                );
                // TODO: Navegar para a tela de alteração de senha
              },
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