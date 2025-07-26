import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product? product =
        ModalRoute.of(context)!.settings.arguments as Product?;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white, // Ensures the text color is white
        title: Text(
          product?.name ?? 'Product Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
