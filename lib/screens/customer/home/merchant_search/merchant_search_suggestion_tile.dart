import 'package:flutter/material.dart';
import 'package:plantngo_frontend/models/merchant_search.dart';
import 'package:plantngo_frontend/widgets/tag/price_tag.dart';
import 'package:plantngo_frontend/widgets/tag/tag.dart';

class MerchantSearchSuggestionTile extends StatelessWidget {
  void Function() onTap;
  MerchantSearch merchant;

  MerchantSearchSuggestionTile({
    super.key,
    required this.onTap,
    required this.merchant,
  });

  renderDistanceTag() {
    if (merchant.distanceFrom != null) {
      return Tag(
        text: "${merchant.distanceFrom!.toStringAsFixed(2)} km",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Image.network(merchant.logoUrl),
      ),
      // horizontalTitleGap: 5,
      title: Text(
        merchant.company,
      ),
      subtitle: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.maxFinite,
        ),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            PriceTag(symbolCount: merchant.priceRating),
            renderDistanceTag(),
            Tag(text: merchant.cuisineType),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
