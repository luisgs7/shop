import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadOrders(),
          builder: (ctx, snaphot) {
            if (snaphot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snaphot.error != null) {
              return const Center(
                child: Text('Ocorreu um erro ao carregar os pedidos'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(
                    order: orders.items[i],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class OrdersPageRef extends StatefulWidget {
  const OrdersPageRef({super.key});

  @override
  State<OrdersPageRef> createState() => _OrdersPageRefState();
}

class _OrdersPageRefState extends State<OrdersPageRef> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(context, listen: false).loadOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (ctx, i) => OrderWidget(
                order: orders.items[i],
              ),
            ),
    );
  }
}
