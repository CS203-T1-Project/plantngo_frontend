import 'package:flutter/material.dart';
import 'package:plantngo_frontend/models/voucher.dart';
import 'package:plantngo_frontend/providers/voucher_shop_provider.dart';
import 'package:plantngo_frontend/screens/customer/voucherShop/voucher_checkout_screen.dart';
import 'package:plantngo_frontend/widgets/card/voucher_card.dart';
import 'package:plantngo_frontend/providers/customer_provider.dart';
import 'package:plantngo_frontend/widgets/custom_icons_icons.dart';
import 'package:provider/provider.dart';

class VoucherShop extends StatefulWidget {
  const VoucherShop({super.key});

  @override
  State<VoucherShop> createState() => _VoucherShopState();
}

class _VoucherShopState extends State<VoucherShop> {
  @override
  void initState() {
    super.initState();
    Provider.of<VoucherShopProvider>(context, listen: false)
        .setVouchers(context);
  }

  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<CustomerProvider>(context, listen: true);
    var voucherShopProvider =
        Provider.of<VoucherShopProvider>(context, listen: true);

    removeVouchers(customerProvider, voucherShopProvider);

    var greenPoints = (customerProvider.customer.greenPoints == null)
        ? 0
        : customerProvider.customer.greenPoints;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Rewards Shop",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: [
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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "Green Points: $greenPoints",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Icon(CustomIcons.leaf, color: Colors.green[400]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: renderVouchers(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(156, 26, 188, 23),
          shape: const CircleBorder(),
          // Lead to checkout page
          onPressed: () {
            Navigator.pushNamed(context, VoucherCheckout.routeName);
          },
          child: const Icon(Icons.shopping_cart, color: Colors.black),
        ),
      ),
    );
  }

  removeVouchers(var customerProvider, var voucherShopProvider) {
    for (Voucher voucher in customerProvider.customer.vouchersCart) {
      if (voucherShopProvider.vouchers.contains(voucher)) {
        voucherShopProvider.vouchers.remove(voucher);
      }
    }

    for (Voucher voucher in customerProvider.customer.ownedVouchers) {
      if (voucherShopProvider.vouchers.contains(voucher)) {
        voucherShopProvider.vouchers.remove(voucher);
      }
    }
  }

  renderVouchers() {
    var voucherShopProvider =
        Provider.of<VoucherShopProvider>(context, listen: true);
    List<Widget> listVouchers = [];
    List<Voucher> allVouchers = voucherShopProvider.vouchers;

    for (int i = 0; i < allVouchers.length; i++) {
      listVouchers.add(VoucherCard(
        voucher: allVouchers[i],
      ));
    }

    return listVouchers.isEmpty
        ? [const Padding(
          padding: EdgeInsets.only(top:20),
          child: Text("No Vouchers Available"),
        )]
        : listVouchers;
  }
}
