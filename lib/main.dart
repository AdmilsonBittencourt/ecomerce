import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/welcome_screen.dart';
import 'package:perfumes_ecomerce/cart_manager.dart'; // Importa o gerenciador de carrinho
import 'package:perfumes_ecomerce/order_manager.dart'; // Importa o gerenciador de pedidos
import 'package:provider/provider.dart'; // Importa o pacote provider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolve todo o aplicativo com MultiProvider para disponibilizar múltiplos gerenciadores
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartManager()), // Disponibiliza o CartManager
        ChangeNotifierProvider(create: (context) => OrderManager()), // Disponibiliza o OrderManager
      ],
      child: MaterialApp(
        title: 'Perfumaria Essência',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}