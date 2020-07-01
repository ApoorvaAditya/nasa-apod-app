import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_save/image_save.dart';
import 'package:provider/provider.dart';

import '../../services/prefs.dart';

class DownloadButton extends StatelessWidget {
  static const String albumName = 'Astronomy Pictures';

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String url;
  const DownloadButton({this.scaffoldKey, this.url});

  Future<void> _saveImage(BuildContext context) async {
    final Prefs prefs = Provider.of<Prefs>(context);
    final http.Response response = await http.get(url);
    final bool success = await ImageSave.saveImage(
      response.bodyBytes,
      "jpg",
      albumName: prefs.getAlbumName(),
    );
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: success ? const Text('Saved Image to $albumName') : const Text('Failed to save image.'),
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
