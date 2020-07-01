import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart' show PhotoView, PhotoViewHeroAttributes;

import '../models/space_media.dart';

class ImageScreen extends StatelessWidget {
  final SpaceMedia spaceMedia;
  final int index;

  const ImageScreen({
    this.spaceMedia,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: PhotoView(
            heroAttributes: PhotoViewHeroAttributes(tag: index),
            minScale: 0.3,
            maxScale: 1.5,
            imageProvider: NetworkImage(
              spaceMedia.hdImageUrl ?? spaceMedia.url,
            ),
          ),
        ),
      ),
    );
  }
}
