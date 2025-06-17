import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/db/database_helper.dart';
import 'package:perfumes_ecomerce/models/user.dart';
import 'package:perfumes_ecomerce/screens/home_screen.dart';
import 'package:perfumes_ecomerce/user_manager.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para validação
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // ... dispose dos controladores ...
    super.dispose();
  }
  
  Future<void> _register() async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() { _isLoading = true; });

    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      // 1. Criar o hash da senha
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // 2. Criar o objeto UserModel (o endereço e nome serão editados depois)
      final newUser = UserModel(
        id: 1, // Nosso app é single-user, então o ID é sempre 1
        name: "Novo Usuário", // Um nome padrão
        email: email,
        address: "Não definido", // Um endereço padrão
        hashedPassword: hashedPassword,
      );
      
      // 3. Chamar o DatabaseHelper para registrar
      final registeredUser = await DatabaseHelper.instance.registerUser(newUser);

      if (mounted) {
        if (registeredUser != null) {
          // Opcional: logar automaticamente o usuário após o registro
          await Provider.of<UserManager>(context, listen: false).fetchUser();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro realizado com sucesso!'), backgroundColor: Colors.green),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este email já está em uso!'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if(mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // ATUALIZADO: Usando um Form para validação
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Crie sua conta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 48),

                // ATUALIZADO: TextFormField com validação
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor, insira um email válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock)),
                   validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmar Senha', prefixIcon: Icon(Icons.lock_reset)),
                   validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  // ATUALIZADO: Lógica do botão
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cadastrar', style: TextStyle(fontSize: 18)),
                ),
                // ... (seu TextButton para voltar para o login) ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}