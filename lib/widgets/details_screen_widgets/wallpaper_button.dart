import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nasa_apod_app/constants.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperButton extends StatelessWidget {
  final String url;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext context;

  const WallpaperButton({
    Key key,
    this.url,
    this.scaffoldKey,
    this.context,
  }) : super(key: key);

  Future<void> setWallpaper(int location) async {
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
    final File file = await DefaultCacheManager().getSingleFile(url);
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
                Text(
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
                  title: Text(
                    'Home Screen Only',
                    textAlign: TextAlign.center,
                    style: whiteTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setWallpaper(WallpaperManager.HOME_SCREEN);
                  },
                ),
                ListTile(
                  title: Text(
                    'Lock Screen Only',
                    textAlign: TextAlign.center,
                    style: whiteTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setWallpaper(WallpaperManager.LOCK_SCREEN);
                  },
                ),
                ListTile(
                  title: Text(
                    'Both Screens',
                    textAlign: TextAlign.center,
                    style: whiteTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
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
    return IconButton(
      icon: Icon(Icons.wallpaper),
      onPressed: () {
        askUser(context);
      },
    );
  }
}
