import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperButton extends StatelessWidget {
  final String url;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WallpaperButton({
    Key key,
    this.url,
    this.scaffoldKey,
  }) : super(key: key);

  Future<void> setWallpaper() async {
    final int location = WallpaperManager.HOME_SCREEN;
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: const Text('Downloading Image'),
        duration: const Duration(days: 365),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {
            scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ),
    );
    final file = await DefaultCacheManager().getSingleFile(url);
    String result;
    try {
      result = await WallpaperManager.setWallpaperFromFile(file.path, location);
    } on PlatformException {
      result = 'Failed to get wallpaper';
    }
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(result),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.wallpaper),
      onPressed: setWallpaper,
    );
  }
}
