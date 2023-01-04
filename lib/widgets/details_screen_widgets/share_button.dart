import 'package:flutter/material.dart';
import 'package:share/share.dart' show Share;

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
        Share.share(url);
      },
    );
  }
}
