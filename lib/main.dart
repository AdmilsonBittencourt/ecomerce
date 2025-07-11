import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/order_manager.dart';
import 'package:provider/provider.dart';
import 'package:perfumes_ecomerce/auth/auth_manager.dart';
import 'package:perfumes_ecomerce/screens/login_screen.dart';
import 'package:perfumes_ecomerce/screens/home_screen.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProxyProvider<AuthManager, OrderManager>(
          create: (context) {
            final authManager = Provider.of<AuthManager>(context, listen: false);
            return OrderManager(authManager.currentUser?.id ?? 0);
          },
          update: (context, authManager, previousOrderManager) {
            previousOrderManager?.updateUserId(authManager.currentUser?.id ?? 0);
            return previousOrderManager ?? OrderManager(authManager.currentUser?.id ?? 0);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Perfumes E-commerce',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authManager = Provider.of<AuthManager>(context, listen: false);
    await authManager.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (context, authManager, _) {
        if (authManager.isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}