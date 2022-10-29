import 'package:flutter/material.dart';
import 'package:plantngo_frontend/models/order.dart';
import 'package:plantngo_frontend/providers/merchant_provider.dart';
import 'package:plantngo_frontend/services/auth_service.dart';
import 'package:plantngo_frontend/services/order_service.dart';
import 'package:plantngo_frontend/widgets/merchantorder/merchant_pending_order_tile.dart';
import 'package:provider/provider.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({super.key});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  List<Order> pendingOrders = [];
  List<MerchantOrderTile> pendingOrderTile = [];
  List<Order> fulfilledOrders = [];
  List<MerchantOrderTile> fulfilledOrderTile = [];
  List<Order> cancelledOrders = [];
  List<MerchantOrderTile> cancelledOrderTile = [];

  Future setPendingOrders() async {
    pendingOrders =
        await OrderService.getPendingOrdersByMerchant(context: context);
    List<MerchantOrderTile> pendingOrderTile = [];

    for (var item in pendingOrders) {
      pendingOrderTile.add(MerchantOrderTile(order: item, refresh: _refresh));
    }
    this.pendingOrderTile = pendingOrderTile;

    fulfilledOrders =
        await OrderService.getFulfilledOrdersByMerchant(context: context);
    List<MerchantOrderTile> fulfilledOrderTile = [];

    for (var item in fulfilledOrders) {
      fulfilledOrderTile.add(MerchantOrderTile(order: item, refresh: _refresh));
    }

    this.fulfilledOrderTile = fulfilledOrderTile;

    cancelledOrders =
        await OrderService.getCancelledOrdersByMerchant(context: context);
    List<MerchantOrderTile> cancelledOrderTile = [];

    for (var item in cancelledOrders) {
      cancelledOrderTile.add(MerchantOrderTile(order: item, refresh: _refresh));
    }

    this.cancelledOrderTile = cancelledOrderTile;
  }

  Future _refresh() async {
    List<Order> pendingOrders =
        await OrderService.getPendingOrdersByMerchant(context: context);
    List<MerchantOrderTile> pendingOrderTile = [];
    for (var item in pendingOrders) {
      pendingOrderTile.add(MerchantOrderTile(order: item, refresh: _refresh));
    }
    List<Order> fulfilledOrders =
        await OrderService.getFulfilledOrdersByMerchant(context: context);
    List<MerchantOrderTile> fulfilledOrderTile = [];
    for (var item in fulfilledOrders) {
      fulfilledOrderTile.add(MerchantOrderTile(order: item, refresh: _refresh));
    }
    List<Order> cancelledOrders =
        await OrderService.getCancelledOrdersByMerchant(context: context);
    List<MerchantOrderTile> cancelledOrderTile = [];
    for (var item in cancelledOrders) {
      cancelledOrderTile.add(MerchantOrderTile(order: item, refresh: _refresh));
    }
    setState(() {
      this.pendingOrders = pendingOrders;
      this.pendingOrderTile = pendingOrderTile;
      this.fulfilledOrders = fulfilledOrders;
      this.fulfilledOrderTile = fulfilledOrderTile;
      this.cancelledOrders = cancelledOrders;
      this.cancelledOrderTile = cancelledOrderTile;
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var merchantProvider = Provider.of<MerchantProvider>(context, listen: true);

    return FutureBuilder(
        future: setPendingOrders(),
        builder: (BuildContext context, snapshot) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Text('${pendingOrders.length} Orders'),
                      ),
                      const Tab(
                        text: 'Fulfilled',
                      ),
                      const Tab(
                        text: 'Cancelled',
                      ),
                    ],
                  ),
                  title: Text(
                    "Hello, ${merchantProvider.merchant.username}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  centerTitle: false,
                ),
                body: TabBarView(children: [
                  RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: pendingOrderTile.length == 0
                              ? [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Center(
                                    child: Column(
                                      children: const [
                                        Icon(
                                          Icons.add_circle,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("No orders, Pull down to refresh")
                                      ],
                                    ),
                                  ),
                                ]
                              : pendingOrderTile)),
                  ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: fulfilledOrderTile),
                  ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: cancelledOrderTile),
                ])),
          );
        });
  }
}
