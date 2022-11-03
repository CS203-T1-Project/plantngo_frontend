import 'package:flutter/material.dart';
import 'package:plantngo_frontend/models/order.dart';
import 'package:plantngo_frontend/models/product.dart';
import 'package:plantngo_frontend/screens/customer/home/merchant_shop/merchant_shop_update_order.dart';

class MerchantShopItem extends StatelessWidget {
  Order? order;
  Product product;

  MerchantShopItem({
    super.key,
    required this.order,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          order != null &&
                  order!.orderItems!.isNotEmpty &&
                  order!.orderItems!
                      .where(
                        (element) => element.productId == product.id,
                      )
                      .isNotEmpty
              ? Container(
                  height: 15,
                  width: 15,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${order!.orderItems!.where((element) => element.productId == product.id).first.quantity!}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox()
        ],
      ),
      title: Text(
        product.name!,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        "\$${product.price!.toStringAsFixed(2)}",
        style: Theme.of(context).textTheme.caption,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MerchantShopUpdateOrder(
              merchantProduct: product,
              customerMerchantOrder: order,
            ),
          ),
        );
      },
    );
  }
}
