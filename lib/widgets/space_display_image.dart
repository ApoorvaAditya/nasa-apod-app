import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SpaceDisplayImage extends StatelessWidget {
  final String url;

  const SpaceDisplayImage({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      image: CachedNetworkImageProvider(url),
      fit: BoxFit.contain,
      progressIndicatorBuilder: (_, ImageChunkEvent progress) {
        double value;
        if (progress != null && progress.expectedTotalBytes != null) {
          value = progress.cumulativeBytesLoaded / progress.expectedTotalBytes;
        }
        return Container(
          height: 300,
          width: double.infinity,
          child: Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(value: value),
            ),
          ),
        );
      },
      errorBuilder: OctoError.icon(color: Colors.red),
    );
  }
}
