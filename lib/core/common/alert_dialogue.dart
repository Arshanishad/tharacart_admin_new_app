import 'package:flutter/material.dart';

 void showAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(" "),
        content: const Text(" "),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(" "),
          ),
          TextButton(
            onPressed: () async {
            },
            child: const Text(" "),
          ),
        ],
      );
    },
  );
}
