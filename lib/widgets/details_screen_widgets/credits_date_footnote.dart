import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../models/space_media.dart';

class CreditsDateFootnote extends StatelessWidget {
  const CreditsDateFootnote({
    Key key,
    @required this.spaceMedia,
  }) : super(key: key);

  final SpaceMedia spaceMedia;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (spaceMedia.credits != null) ...[
          Icon(
            Icons.copyright,
            color: Colors.white54,
          ),
          const SizedBox(width: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: HtmlWidget(
              spaceMedia.credits.split('<br>')[1].trim(),
              textStyle: const TextStyle(
                color: Colors.white54,
              ),
              hyperlinkColor: Colors.white54,
            ),
          ),
        ] else ...[
          const Text(
            'Public Domain',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
        const Spacer(),
        Text(
          DateFormat.yMMMMd().format(spaceMedia.date),
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
