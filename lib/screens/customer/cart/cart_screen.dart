import 'package:flutter/material.dart';
import 'package:plantngo_frontend/models/order.dart';
import 'package:plantngo_frontend/screens/customer/cart/cart_order_list.dart';
import 'package:plantngo_frontend/services/customer_order_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Order>> futureCustomerOrders;

  @override
  void initState() {
    super.initState();
    setState(() {
      futureCustomerOrders =
          CustomerOrderService.getAllOrdersByCustomerAndOrderStatus(
        context: context,
        orderStatus: "CREATED",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade200,
                Colors.green.shade300,
                Colors.green,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            FutureBuilder<List<Order>>(
              future: futureCustomerOrders,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load page"),
                  );
                } else if (snapshot.hasData
                    // && snapshot.data!.isNotEmpty
                    ) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 30,
                      );
                    },
                    itemBuilder: (context, index) {
                      final result = snapshot.data![index];
                      return CartOrderList(order: result);
                    },
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No Results"),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
