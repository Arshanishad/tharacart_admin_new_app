import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Zoom extends StatefulWidget {
  final String image;
  const Zoom({Key? key, required this.image,}) : super(key: key);

  @override
  _ZoomState createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.image),
        ),
      ),
    );
  }
}