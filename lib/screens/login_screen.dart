import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/register_screen.dart'; // Importa a tela de registro
import 'package:perfumes_ecomerce/screens/home_screen.dart'; // Importa a tela principal (placeholder)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0, // Remove a sombra da AppBar para um visual minimalista
        iconTheme: const IconThemeData(color: Colors.black87), // Cor do ícone de voltar
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // Permite rolar a tela se o teclado aparecer
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Título
              const Text(
                'Bem-vindo de volta!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),

              // Campo de Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'seuemail@exemplo.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black87, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Senha
              TextField(
                controller: _passwordController,
                obscureText: true, // Esconde o texto digitado (para senhas)
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Sua senha secreta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black87, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 24),

              // Botão de Login
              ElevatedButton(
                onPressed: () {
                  // TODO: Adicionar lógica de autenticação aqui
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  print('Email: $email, Senha: $password'); // Apenas para debug

                  // Por enquanto, apenas navega para a tela Home
                  Navigator.pushReplacement( // Usa pushReplacement para não permitir voltar para o login
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: const Size.fromHeight(50), // Faz o botão ocupar a largura disponível
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // Texto para registrar
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Não tem uma conta? Cadastre-se aqui',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}