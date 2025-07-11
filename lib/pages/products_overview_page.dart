import 'package:flutter/material.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = provider.items;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Minha Loja',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, i) => ProductItem(loadedProducts[i]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ));
  }
}
