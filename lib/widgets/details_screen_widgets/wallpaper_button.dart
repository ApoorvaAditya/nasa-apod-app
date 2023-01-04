import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:nasa_apod_app/constants.dart';
import 'package:nasa_apod_app/services/settings_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperButton extends StatelessWidget {
  final String? url;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final BuildContext? context;

  const WallpaperButton({
    super.key,
    this.url,
    this.scaffoldKey,
    this.context,
  });

  Future<void> setWallpaper(int location) async {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: const Text('Downloading Image'),
        duration: const Duration(days: 365),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {
            ScaffoldMessenger.of(context!).hideCurrentSnackBar();
          },
        ),
      ),
    );

    final DefaultCacheManager cacheManager = DefaultCacheManager();
    final FileInfo downloadedFile = await cacheManager.downloadFile(url!);
    final File rawWallpaperFile = downloadedFile.file;
    final File croppedWallpaperImage = await cropWallpaper(rawWallpaperFile);

    String result;
    try {
      result = await WallpaperManager.setWallpaperFromFile(croppedWallpaperImage.path, location);
    } on PlatformException {
      result = 'Failed to get wallpaper';
    }

    ScaffoldMessenger.of(context!).hideCurrentSnackBar();
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(result),
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<File> cropWallpaper(File file) async {
    final Directory cacheDirectory = await getTemporaryDirectory();
    final String imagePath = '${cacheDirectory.path}/wallpaper.png';

    final SettingsProvider settings = Provider.of<SettingsProvider>(context!, listen: false);
    final wallpaperCropMethod = settings.getWallpaperCropMethod();

    final img.Image rawWallpaper = img.decodeImage(file.readAsBytesSync())!;
    final int imageHeight = rawWallpaper.height;
    final int imageWidth = rawWallpaper.width;
    final MediaQueryData mediaQuery = MediaQuery.of(context!);
    final double screenAspectRatio = mediaQuery.size.aspectRatio;
    final double imageAspectRatio = imageWidth / imageHeight;

    if (imageAspectRatio > screenAspectRatio) {
      if (wallpaperCropMethod == WallpaperCropMethod.alwaysFit ||
          wallpaperCropMethod == WallpaperCropMethod.alwaysFitHeight) {
        final int newWidth = (screenAspectRatio * imageHeight).toInt();
        final int newHeight = imageHeight;
        final int x = (imageWidth - newWidth) ~/ 2;
        const int y = 0;
        return File(imagePath)
          ..writeAsBytesSync(
            img.encodePng(
              img.copyCrop(
                rawWallpaper,
                x,
                y,
                newWidth,
                newHeight,
              ),
            ),
          );
      } else if (wallpaperCropMethod == WallpaperCropMethod.alwaysFit ||
          wallpaperCropMethod == WallpaperCropMethod.alwaysFitWidth) {
        final int newWidth = (screenAspectRatio * imageHeight).toInt();
        final int newHeight = imageHeight;
        final int x = (imageWidth - newWidth) ~/ 2;
        const int y = 0;
        return File(imagePath)
          ..writeAsBytesSync(
            img.encodePng(
              img.drawImage(
                img.fill(
                  img.Image(
                    newWidth,
                    newHeight,
                  ),
                  img.Color.fromRgb(0, 0, 0),
                ),
                rawWallpaper,
                dstX: x,
                dstY: y,
              ),
            ),
          );
      }
    } else if (imageAspectRatio < screenAspectRatio) {
      if (wallpaperCropMethod == WallpaperCropMethod.alwaysFit ||
          wallpaperCropMethod == WallpaperCropMethod.alwaysFitWidth) {
        final int newWidth = imageWidth;
        final int newHeight = imageWidth ~/ screenAspectRatio;
        const int x = 0;
        final int y = (imageHeight - newHeight) ~/ 2;
        return File(imagePath)
          ..writeAsBytesSync(
            img.encodePng(
              img.copyCrop(
                rawWallpaper,
                x,
                y,
                newWidth,
                newHeight,
              ),
            ),
          );
      } else if (wallpaperCropMethod == WallpaperCropMethod.alwaysFit ||
          wallpaperCropMethod == WallpaperCropMethod.alwaysFitHeight) {
        final int newWidth = imageWidth;
        final int newHeight = imageWidth ~/ screenAspectRatio;
        const int x = 0;
        final int y = (imageHeight - newHeight) ~/ 2;
        return File(imagePath)
          ..writeAsBytesSync(
            img.encodePng(
              img.drawImage(
                img.fill(
                  img.Image(newWidth, newHeight),
                  img.Color.fromRgb(0, 0, 0),
                ),
                rawWallpaper,
                dstX: x,
                dstY: y,
              ),
            ),
          );
      }
    }
    return file;
  }

  void askUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        color: darkBlue,
        child: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Set Wallpaper',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  height: 1,
                  color: Colors.white,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Home Screen Only',
                    style: whiteTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setWallpaper(WallpaperManager.HOME_SCREEN);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.screen_lock_portrait,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Lock Screen Only',
                    style: whiteTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setWallpaper(WallpaperManager.LOCK_SCREEN);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.filter,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Both Screens',
                    style: whiteTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setWallpaper(WallpaperManager.BOTH_SCREENS);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    final DefaultWallpaperScreen screen = settings.getDefaultWallpaperScreen();
    return IconButton(
      icon: const Icon(Icons.wallpaper),
      onPressed: () {
        if (screen == DefaultWallpaperScreen.alwaysAsk) {
          askUser(context);
        } else {
          setWallpaper(screen.index);
        }
      },
    );
  }
}
