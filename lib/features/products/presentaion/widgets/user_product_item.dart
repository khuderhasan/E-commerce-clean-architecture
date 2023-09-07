import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocs/add_update_delete_product_bloc/add_update_delete_product_bloc_bloc.dart';

import '../pages/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final double price;
  final String imageUrl;

  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
    this.description,
    this.price, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: {
                  "id": id,
                  "title": title,
                  "description": description,
                  "price": price,
                  "imageUrl": imageUrl
                });
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<AddUpdateDeleteProductBloc>(context)
                    .add(DeleteProductEvent(productId: id));
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            )
          ],
        ),
      ),
    );
  }
}
