import 'package:flutter/material.dart';
import 'package:image_save/image_save.dart';
import 'package:http/http.dart' as http;

class DownloadButton extends StatelessWidget {
  static const String albumName = 'Astronomy Pictures';

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String url;
  const DownloadButton({this.scaffoldKey, this.url});

  Future<void> _saveImage() async {
    final http.Response response = await http.get(url);
    final bool success = await ImageSave.saveImage(
      response.bodyBytes,
      "jpg",
      albumName: albumName,
    );
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: success
            ? const Text('Saved Image to $albumName')
            : const Text('Failed to save image.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.file_download),
      onPressed: _saveImage,
    );
  }
}
