import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parseFragment;

import '../models/space_media.dart';
import '../screens/details_screen.dart' show DetailsScreen;
import 'space_display_image.dart';

class ImageCard extends StatelessWidget {
  static const double cardBorderRadius = 10;
  final int index;
  final SpaceMedia spaceMedia;
  final String comingFrom;
  final void Function(int idx) scrollToFunction;

  const ImageCard({
    Key key,
    @required this.index,
    @required this.spaceMedia,
    @required this.comingFrom,
    this.scrollToFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final indexOfViewedItem = await Navigator.of(context).pushNamed(DetailsScreen.routeName, arguments: {
          'enablePageView': true,
          'spaceMedia': spaceMedia,
          'index': index,
          'comingFrom': comingFrom,
        });
        scrollToFunction(indexOfViewedItem as int);
      },
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ImageCard.cardBorderRadius),
        ),
        child: Stack(
          children: <Widget>[
            CardImage(
              index: index,
              url: spaceMedia.url,
              type: spaceMedia.type,
            ),
            const TextBackground(cardBorderRadius: cardBorderRadius),
            SpaceMediaMinimizedDetails(
              index: index,
              title: spaceMedia.title,
              description: spaceMedia.description,
            ),
          ],
        ),
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  final int index;
  final String url;
  final String type;

  const CardImage({
    Key key,
    this.index,
    this.url,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ImageCard.cardBorderRadius),
      child: Hero(
        tag: index,
        child: SpaceDisplayImage(
          url: url,
          type: type,
        ),
      ),
    );
  }
}

class TextBackground extends StatelessWidget {
  const TextBackground({
    Key key,
    @required this.cardBorderRadius,
  }) : super(key: key);

  final double cardBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(ImageCard.cardBorderRadius),
          bottomRight: Radius.circular(ImageCard.cardBorderRadius),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 8,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black12, Colors.transparent],
              stops: const [0.0, 0.7, 1.0],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
    );
  }
}

class SpaceMediaMinimizedDetails extends StatelessWidget {
  final int index;
  final String description;
  final String title;

  const SpaceMediaMinimizedDetails({
    Key key,
    this.index,
    this.description,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 25,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          children: <Widget>[
            SpaceMediaMinimizedTitle(
              index: index,
              title: title,
            ),
            SpaceMediaMinimizedDescription(
              description: description,
            ),
          ],
        ),
      ),
    );
  }
}

class SpaceMediaMinimizedTitle extends StatelessWidget {
  final int index;
  final String title;

  const SpaceMediaMinimizedTitle({
    Key key,
    this.index,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${index.toString()}title',
      child: Text(
        title ?? '',
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
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

class SpaceMediaMinimizedDescription extends StatelessWidget {
  final String description;

  const SpaceMediaMinimizedDescription({
    Key key,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      parseFragment(description).text ?? '',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
