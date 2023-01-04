import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/screens/details_screen.dart' show DetailsScreen;
import 'package:nasa_apod_app/widgets/space_display_image.dart';

class ImageCard extends StatelessWidget {
  static const double cardBorderRadius = 10;
  final int index;
  final SpaceMedia spaceMedia;
  final String comingFrom;
  final void Function(int idx) scrollToFunction;

  const ImageCard({
    super.key,
    required this.index,
    required this.spaceMedia,
    required this.comingFrom,
    required this.scrollToFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final int indexOfViewedItem = await Navigator.of(context).pushNamed(
              DetailsScreen.routeName,
              arguments: {
                'enablePageView': true,
                'spaceMedia': spaceMedia,
                'index': index,
                'comingFrom': comingFrom,
              },
            ) as int? ??
            0;
        scrollToFunction(indexOfViewedItem);
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
    super.key,
    required this.index,
    required this.url,
    required this.type,
  });

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
    super.key,
    required this.cardBorderRadius,
  });

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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black12, Colors.transparent],
              stops: [0.0, 0.7, 1.0],
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
    super.key,
    required this.index,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 25,
      child: SizedBox(
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
    super.key,
    required this.index,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${index.toString()}title',
      child: Text(
        title,
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
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

class SpaceMediaMinimizedDescription extends StatelessWidget {
  final String description;

  const SpaceMediaMinimizedDescription({
    super.key,
    required this.description,
  });

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
