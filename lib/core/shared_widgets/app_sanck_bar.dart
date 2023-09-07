import 'package:flutter/material.dart';

SnackBar appSnackBar({required String text}) => SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
