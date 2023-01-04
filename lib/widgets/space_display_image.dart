import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod_app/utils.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';

class SpaceDisplayImage extends StatelessWidget {
  final String url;
  final String type;

  const SpaceDisplayImage({
    Key? key,
    required this.url,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      type == 'image' ? url : Utils.getYtThumbnailLink(url),
      fit: BoxFit.contain,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const SizedBox(
              height: 300,
              width: double.infinity,
              child: CenteredCircularProgressIndicator(),
            );
            break;
          case LoadState.completed:
            return Stack(
              children: <Widget>[
                ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                ),
                if (type == 'video')
                  const Positioned.fill(
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
              child: const SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: Icon(Icons.replay),
                ),
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
