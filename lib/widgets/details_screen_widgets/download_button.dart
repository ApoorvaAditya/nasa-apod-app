import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_save/image_save.dart';
import 'package:provider/provider.dart';

import '../../services/settings_provider.dart';

class DownloadButton extends StatelessWidget {
  static const String albumName = 'Astronomy Pictures';

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String url;
  const DownloadButton({this.scaffoldKey, this.url});

  Future<void> _saveImage(BuildContext context) async {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: const Text('Downloading Image...'),
        duration: const Duration(
          days: 365,
        ),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),
        ),
      ),
    );

    final SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    http.Response response;
    bool errorEncountered = false;
    bool success = false;
    try {
      response = await http.get(url);
      success = await ImageSave.saveImage(
        response.bodyBytes,
        "jpg",
        albumName: settings.getAlbumName(),
      );
    } catch (_) {
      errorEncountered = true;
    }

    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: (success && !errorEncountered)
            ? const Text('Saved Image to $albumName')
            : const Text('Failed to save image.'),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.file_download),
      onPressed: () {
        _saveImage(context);
      },
    );
  }
}
