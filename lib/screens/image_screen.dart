import 'package:flutter/material.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:photo_view/photo_view.dart' show PhotoView, PhotoViewHeroAttributes;

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
        decoration: const BoxDecoration(color: Colors.black),
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
