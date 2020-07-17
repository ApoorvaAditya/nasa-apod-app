import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../models/space_media.dart';
import '../services/saved_provider.dart';
import '../strings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/image_card.dart';

class SavedScreen extends StatelessWidget {
  static const routeName = '/saved';

  final AutoScrollController _autoController = AutoScrollController();

  void scrollToIndex(int index) {
    _autoController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final SavedProvider savedProvider = Provider.of<SavedProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(
        prevScreen: routeName,
      ),
      body: BackgroundGradient(
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          controller: _autoController,
          slivers: <Widget>[
            const SliverAppBar(
              title: Text(Strings.savedScreenTitle),
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return AutoScrollTag(
                    controller: _autoController,
                    key: ValueKey(index),
                    index: index,
                    child: ImageCard(
                      index: index,
                      comingFrom: SavedScreen.routeName,
                      spaceMedia: savedProvider.spaceMedias[index] as SpaceMedia,
                      scrollToFunction: scrollToIndex,
                    ),
                  );
                },
                childCount: savedProvider.spaceMedias.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
