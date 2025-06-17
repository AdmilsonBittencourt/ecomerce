import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:perfumes_ecomerce/order_manager.dart';
import 'package:perfumes_ecomerce/perfume_manager.dart';
import 'package:perfumes_ecomerce/screens/auth_gate.dart';
import 'package:perfumes_ecomerce/user_manager.dart';
import 'package:provider/provider.dart';

void main() {
  // Garante que os plugins do Flutter sejam inicializados antes de rodar o app.
  // É uma boa prática, especialmente quando se lida com acesso a banco de dados.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolve todo o aplicativo com MultiProvider para disponibilizar múltiplos gerenciadores
    return MultiProvider(
      providers: [
        // Registra todos os nossos "cérebros"
        ChangeNotifierProvider(create: (_) => UserManager()),
        ChangeNotifierProvider(create: (_) => PerfumeManager()),
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProvider(create: (_) => OrderManager()),
      ],
      child: MaterialApp(
        title: 'Perfumaria Essência',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey, // Uma cor base neutra
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // ATUALIZADO: A tela inicial agora é o nosso "portão de autenticação"
        home: const AuthGate(),
      ),
    );
  }
}