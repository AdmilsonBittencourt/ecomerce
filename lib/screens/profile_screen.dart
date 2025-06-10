import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados de exemplo para o perfil do usuário
    const String userName = 'João da Silva';
    const String userEmail = 'joao.silva@exemplo.com';
    const String userAddress = 'Rua das Flores, 123 - Cidade, Estado';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87), // Cor da seta de voltar
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza os elementos
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

            // Nome do Usuário
            Text(
              userName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Email do Usuário
            Text(
              userEmail,
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
                subtitle: Text(userEmail),
                trailing: const Icon(Icons.edit, color: Colors.black26), // Ícone de edição
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar email (em breve!)')),
                  );
                },
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
                subtitle: Text(userAddress),
                trailing: const Icon(Icons.edit, color: Colors.black26),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar endereço (em breve!)')),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Botões de Ação
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Edição de Perfil (em breve!)')),
                );
                // TODO: Navegar para a tela de edição de perfil
              },
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