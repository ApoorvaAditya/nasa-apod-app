import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_save/image_save.dart';
import 'package:nasa_apod_app/services/settings_provider.dart';
import 'package:provider/provider.dart';

class DownloadButton extends StatelessWidget {
  static const String albumName = 'Astronomy Pictures';

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String url;
  const DownloadButton({this.scaffoldKey, this.url});

  Future<void> _saveImage(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Downloading Image...'),
        duration: const Duration(
          days: 365,
        ),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );

    final SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    http.Response response;
    bool errorEncountered = false;
    bool success = false;
    try {
      response = await http.get(Uri(path: url));
      success = await ImageSave.saveImage(
        response.bodyBytes,
        "jpg",
        albumName: settings.getAlbumName(),
      );
    } catch (_) {
      errorEncountered = true;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
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
      icon: const Icon(Icons.file_download),
      onPressed: () {
        _saveImage(context);
      },
    );
  }
}
