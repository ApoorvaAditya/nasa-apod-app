import 'package:flutter/material.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/screens/saved_screen.dart';
import 'package:nasa_apod_app/services/saved_provider.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatefulWidget {
  final SpaceMedia spaceMedia;
  final String comingFrom;

  const SaveButton({
    super.key,
    required this.spaceMedia,
    required this.comingFrom,
  });
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
            context: widget.comingFrom == SavedScreen.routeName ? context : null,
          );
        }
        setState(() {
          toggle = !toggle;
        });
      },
    );
  }
}
