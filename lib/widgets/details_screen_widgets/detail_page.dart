import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/screens/image_screen.dart';
import 'package:nasa_apod_app/services/settings_provider.dart';
import 'package:nasa_apod_app/utils.dart';
import 'package:nasa_apod_app/widgets/details_screen_widgets/credits_date_footnote.dart';
import 'package:nasa_apod_app/widgets/details_screen_widgets/download_button.dart';
import 'package:nasa_apod_app/widgets/details_screen_widgets/save_button.dart';
import 'package:nasa_apod_app/widgets/details_screen_widgets/share_button.dart';
import 'package:nasa_apod_app/widgets/details_screen_widgets/wallpaper_button.dart';
import 'package:nasa_apod_app/widgets/space_display_image.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.spaceMedia,
    required this.topPadding,
    required this.titleTheme,
    required this.index,
  });

  final SpaceMedia spaceMedia;
  final double topPadding;
  final TextStyle? titleTheme;
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

class DetailsAppBar extends StatelessWidget with PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final SpaceMedia spaceMedia;
  final String? comingFrom;
  final int? index;

  DetailsAppBar({
    super.key,
    required this.scaffoldKey,
    required this.spaceMedia,
    required this.comingFrom,
    this.index,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context, index);
        },
      ),
      actions: <Widget>[
        SaveButton(
          spaceMedia: spaceMedia,
          comingFrom: comingFrom,
        ),
        WallpaperButton(
          url: spaceMedia.hdImageUrl ?? spaceMedia.url,
          scaffoldKey: scaffoldKey,
          context: context,
        ),
        if (spaceMedia.type == 'image')
          DownloadButton(
            scaffoldKey: scaffoldKey,
            url: spaceMedia.hdImageUrl ?? spaceMedia.url,
          ),
        ShareButton(
          url: spaceMedia.url,
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
    super.key,
    required this.spaceMedia,
    required this.topPadding,
    required this.index,
  });

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
    super.key,
    required this.spaceMedia,
    required this.titleTheme,
    required this.index,
  });

  final SpaceMedia spaceMedia;
  final TextStyle? titleTheme;
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
        const Divider(color: Colors.white54),
        SpaceMediaDescription(description: spaceMedia.description),
        const Divider(color: Colors.white54),
        CreditsDateFootnote(spaceMedia: spaceMedia)
      ],
    );
  }
}

class SpaceMediaTitle extends StatelessWidget {
  const SpaceMediaTitle({
    super.key,
    required this.title,
    required this.titleTheme,
    required this.index,
  });

  final String title;
  final int index;
  final TextStyle? titleTheme;

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
          fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
        ),
      ),
    );
  }
}

class SpaceMediaDescription extends StatelessWidget {
  const SpaceMediaDescription({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = Provider.of<SettingsProvider>(context);
    return HtmlWidget(
      '<p>$description</p>',
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: settings.getFontSize(),
      ),
      customStylesBuilder: (element) {
        switch (element.localName) {
          case 'a':
            return {'text-decoration': 'none', 'color': '#2196F3'};
          case 'p':
            return {'text-align': 'justify'};
        }
        return null;
      },
    );
  }
}
