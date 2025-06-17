import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/register_screen.dart'; // Importa a tela de registro
import 'package:perfumes_ecomerce/screens/home_screen.dart'; // Importa a tela principal (placeholder)
import 'package:perfumes_ecomerce/database/database_helper.dart';
import 'package:perfumes_ecomerce/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validação básica
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _databaseHelper.getUserByEmail(email);
      
      if (user == null) {
        setState(() {
          _errorMessage = 'Usuário não encontrado.';
          _isLoading = false;
        });
        return;
      }

      if (user.password != password) {
        setState(() {
          _errorMessage = 'Senha incorreta.';
          _isLoading = false;
        });
        return;
      }

      // Login bem-sucedido
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer login. Tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),

              // Campo de Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
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
                enabled: !_isLoading,
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
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: const Size.fromHeight(50), // Faz o botão ocupar a largura disponível
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 16),

              // Texto para registrar
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
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