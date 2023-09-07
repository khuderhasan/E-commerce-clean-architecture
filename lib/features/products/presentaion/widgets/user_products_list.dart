import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import 'user_product_item.dart';

class UserProductsList extends StatelessWidget {
  final List<Product> productsData;

  const UserProductsList({
    Key? key,
    required this.productsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemBuilder: (_, i) => Column(
          children: [
            UserProductItem(
                productsData[i].id!,
                productsData[i].title,
                productsData[i].imageUrl,
                productsData[i].description,
                productsData[i].price),
            const Divider(),
          ],
        ),
        itemCount: productsData.length,
      ),
    );
  }
}
