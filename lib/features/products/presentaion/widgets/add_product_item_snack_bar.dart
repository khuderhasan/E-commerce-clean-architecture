import 'package:flutter/material.dart';

SnackBar addProductItemSnackBar(void Function() onPressed) {
  return SnackBar(
    content: const Text(
      'Item was add to cart',
    ),
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: 'UNDO',
      textColor: Colors.deepOrange,
      onPressed: () {
        onPressed();
      },
    ),
  );
}
