import 'package:flutter/material.dart';

// Importa a tela de login que criaremos a seguir
import 'package:perfumes_ecomerce/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco para um toque minimalista
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Título de Boas-Vindas
              Text(
                'Bem-vindo à Perfumaria Essência',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Cor escura para contraste
                ),
              ),
              const SizedBox(height: 16), // Espaçamento
              // Subtítulo
              Text(
                'Descubra sua fragrância perfeita.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48), // Espaçamento maior antes do botão
              // Botão para iniciar
              ElevatedButton(
                onPressed: () {
                  // Navega para a tela de Login quando o botão é pressionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87, // Fundo do botão escuro
                  foregroundColor: Colors.white, // Texto do botão branco
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                  ),
                ),
                child: const Text(
                  'Começar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}