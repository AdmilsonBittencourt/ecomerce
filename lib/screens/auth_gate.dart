import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/db/database_helper.dart';
import 'package:perfumes_ecomerce/screens/login_screen.dart';
import 'package:perfumes_ecomerce/screens/register_screen.dart';
// Importe sua tela de login

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos um FutureBuilder para verificar o estado do banco ANTES de decidir a tela
    return FutureBuilder<bool>(
      // A nossa "future" é a verificação se o usuário de ID=1 existe.
      // O método `getUser()` retorna um `UserModel?`, então verificamos se não é nulo.
      future: DatabaseHelper.instance.getUser().then((user) => user != null),
      builder: (context, snapshot) {
        // Enquanto a verificação está acontecendo, mostramos uma tela de carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se a verificação terminou
        if (snapshot.hasData) {
          final userExists = snapshot.data!;

          // Se o usuário existe, vai para a tela de Login.
          // Se não existe, vai para a tela de Registro.
          return userExists ? const LoginScreen() : const RegisterScreen();
        }

        // Em caso de erro na verificação (pouco provável)
        return const Scaffold(
          body: Center(child: Text('Erro ao verificar autenticação.')),
        );
      },
    );
  }
}