import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import '../utils.dart';

class SpaceDisplayImage extends StatelessWidget {
  final String url;
  final String type;

  const SpaceDisplayImage({
    Key key,
    this.url,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      type == 'image' ? url : Utils.getYtThumbnailLink(url),
      cache: true,
      fit: BoxFit.contain,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
              height: 300,
              width: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          case LoadState.completed:
            return Stack(
              children: <Widget>[
                ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                ),
                if (type == 'video')
                  Positioned.fill(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
              ],
            );
            break;
          case LoadState.failed:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Center(
                child: Icon(Icons.replay),
              ),
            );
            break;
          default:
            return null;
        }
      },
    );
  }
}
