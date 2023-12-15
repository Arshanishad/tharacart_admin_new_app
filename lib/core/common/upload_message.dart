
import 'package:flutter/material.dart';

void showUploadMessage(BuildContext context, String message,
    {bool showLoading = false,}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor:Colors.black,
        duration: showLoading?const Duration(minutes: 30):const Duration(seconds: 4),
        content: Row(
          children: [
            if (showLoading)
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: CircularProgressIndicator(),
              ),
            Text(message,),
          ],
        ),
      ),
    );
}