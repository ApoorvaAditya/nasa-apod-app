import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/space_media.dart';
import '../services/saved_provider.dart';
import '../strings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/image_card.dart';

class SavedScreen extends StatelessWidget {
  static const routeName = '/saved';

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
          slivers: <Widget>[
            const SliverAppBar(
              title: Text(Strings.savedScreenTitle),
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return ImageCard(
                    index: index,
                    comingFrom: SavedScreen.routeName,
                    spaceMedia: savedProvider.spaceMedias[index] as SpaceMedia,
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
