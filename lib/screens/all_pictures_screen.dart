import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/space_media.dart';
import '../services/media.dart';
import '../strings.dart';
import '../utils.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/creation_aware_widget.dart';
import '../widgets/image_card.dart';

class AllPicturesScreeen extends StatelessWidget {
  static const routeName = '/all-pics';

  @override
  Widget build(BuildContext context) {
    final Media media = Provider.of<Media>(context);
    final List<SpaceMedia> spaceMedias = media.spaceMedias;

    return Scaffold(
      drawer: const AppDrawer(prevScreen: routeName),
      extendBodyBehindAppBar: true,
      body: BackgroundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              title: Text(Strings.allPicturesScreenTitle),
              floating: true,
            ),
            SliverAnimatedList(
              itemBuilder: (_, index, animation) {
                if (spaceMedias.isEmpty) {
                  return Container(
                    height: Utils.getHeightOfPage(context),
                    width: double.infinity,
                    child: const CenteredCircularProgressIndicator(),
                  );
                }
                if (index + 1 > spaceMedias.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                }
                return CreationAwareWidget(
                  itemCreated: () {
                    if (index + 3 >= spaceMedias.length) {
                      media.loadMore();
                    }
                  },
                  child: FadeTransition(
                    opacity: animation,
                    child: ImageCard(
                      index: index,
                      spaceMedia: spaceMedias[index],
                    ),
                  ),
                );
              },
              initialItemCount: spaceMedias.length + 1,
            ),
          ],
        ),
      ),
    );
  }
}
