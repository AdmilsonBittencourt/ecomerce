import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:perfumes_ecomerce/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (context, cartManager, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            if (cartManager.itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: Text(
                    cartManager.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}