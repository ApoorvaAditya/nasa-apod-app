import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nasa_apod_app/services/hive_provider.dart';
import 'package:provider/provider.dart';

import '../../models/space_media.dart';
import '../../screens/image_screen.dart';
import '../../utils.dart';
import '../../widgets/space_display_image.dart';
import '../details_screen_widgets/download_button.dart';
import '../details_screen_widgets/share_button.dart';
import 'credits_date_footnote.dart';
import 'wallpaper_button.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    Key key,
    @required this.spaceMedia,
    @required this.topPadding,
    @required this.titleTheme,
    @required this.index,
  }) : super(key: key);

  final SpaceMedia spaceMedia;
  final double topPadding;
  final TextStyle titleTheme;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SpaceMediaImage(
            spaceMedia: spaceMedia,
            topPadding: topPadding,
            index: index,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SpaceTextColumn(
              spaceMedia: spaceMedia,
              titleTheme: titleTheme,
              index: index,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsAppBar extends StatefulWidget with PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final SpaceMedia spaceMedia;

  DetailsAppBar({
    Key key,
    this.scaffoldKey,
    this.spaceMedia,
  }) : super(key: key);

  @override
  _DetailsAppBarState createState() => _DetailsAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _DetailsAppBarState extends State<DetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    final hiveProvider = Provider.of<SavedProvider>(context);
    bool toggle = false;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            toggle ? Icons.bookmark : Icons.bookmark_border,
          ),
          onPressed: () {
            if (toggle) {
              hiveProvider.removeSpaceMedia(widget.spaceMedia.date);
            } else {
              hiveProvider.addSpaceMedia(widget.spaceMedia);
            }
            setState(() {
              toggle = !toggle;
            });
          },
        ),
        WallpaperButton(
          url: widget.spaceMedia.hdImageUrl ?? widget.spaceMedia.url,
          scaffoldKey: widget.scaffoldKey,
          context: context,
        ),
        if (widget.spaceMedia.type == 'image')
          DownloadButton(
            scaffoldKey: widget.scaffoldKey,
            url: widget.spaceMedia.hdImageUrl ?? widget.spaceMedia.url,
          ),
        ShareButton(
          url: widget.spaceMedia.url,
        ),
      ],
    );
  }
}

class SpaceMediaImage extends StatelessWidget {
  final SpaceMedia spaceMedia;
  final double topPadding;
  final int index;
  const SpaceMediaImage({
    Key key,
    @required this.spaceMedia,
    @required this.topPadding,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: GestureDetector(
        onTap: () {
          if (spaceMedia.type == 'image') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ImageScreen(
                  spaceMedia: spaceMedia,
                  index: index,
                ),
              ),
            );
          } else if (spaceMedia.type == 'video') {
            Utils.launchURL(spaceMedia.url);
          }
        },
        child: Hero(
          tag: index,
          child: SpaceDisplayImage(
            url: spaceMedia.url,
            type: spaceMedia.type,
          ),
        ),
      ),
    );
  }
}

class SpaceTextColumn extends StatelessWidget {
  const SpaceTextColumn({
    Key key,
    @required this.spaceMedia,
    @required this.titleTheme,
    @required this.index,
  }) : super(key: key);

  final SpaceMedia spaceMedia;
  final TextStyle titleTheme;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SpaceMediaTitle(
          title: spaceMedia.title,
          titleTheme: titleTheme,
          index: index,
        ),
        Divider(color: Colors.white54),
        SpaceMediaDescription(description: spaceMedia.description),
        Divider(color: Colors.white54),
        CreditsDateFootnote(spaceMedia: spaceMedia)
      ],
    );
  }
}

class SpaceMediaTitle extends StatelessWidget {
  const SpaceMediaTitle({
    Key key,
    @required this.title,
    @required this.titleTheme,
    @required this.index,
  }) : super(key: key);

  final String title;
  final int index;
  final TextStyle titleTheme;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${index.toString()}title',
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
          fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        ),
      ),
    );
  }
}

class SpaceMediaDescription extends StatelessWidget {
  const SpaceMediaDescription({
    Key key,
    @required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      '<p>$description</p>',
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      hyperlinkColor: Colors.lightBlue,
      customStylesBuilder: (element) {
        switch (element.localName) {
          case 'a':
            return ['text-decoration', 'none'];
          case 'p':
            return ['text-align', 'justify'];
        }
        return null;
      },
    );
  }
}
