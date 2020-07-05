import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/space_media.dart';
import '../../services/saved_provider.dart';

class SaveButton extends StatefulWidget {
  final SpaceMedia spaceMedia;

  const SaveButton({
    Key key,
    this.spaceMedia,
  }) : super(key: key);
  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    final SavedProvider savedProvider = Provider.of<SavedProvider>(context);
    bool toggle = savedProvider.dates.contains(widget.spaceMedia.date);

    return IconButton(
      icon: Icon(
        toggle ? Icons.bookmark : Icons.bookmark_border,
      ),
      onPressed: () {
        if (!toggle) {
          savedProvider.addSpaceMedia(widget.spaceMedia);
        } else {
          savedProvider.removeSpaceMedia(
            spaceMedia: widget.spaceMedia,
            context: context,
          );
        }
        setState(() {
          toggle = !toggle;
        });
      },
    );
  }
}
