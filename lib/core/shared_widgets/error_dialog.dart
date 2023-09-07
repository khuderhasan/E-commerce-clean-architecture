import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, String stateMessage) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Error",
        style: TextStyle(color: Colors.red),
      ),
      content: Text(stateMessage),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    ),
  );
}
