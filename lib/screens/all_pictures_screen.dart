import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/media.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/creation_aware_widget.dart';
import '../widgets/image_card.dart';

class AllPicturesScreeen extends StatelessWidget {
  static const routeName = '/all-pics';

  @override
  Widget build(BuildContext context) {
    final Media media = Provider.of<Media>(context);

    return Scaffold(
      drawer: const AppDrawer(prevScreen: routeName),
      extendBodyBehindAppBar: true,
      body: BackgroundGradient(
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              title: Text('All Pictures'),
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  if (media.spaceMedias.isEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
                      width: double.infinity,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    );
                  }
                  if (index + 1 > media.spaceMedias.length) {
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
                      if (index + 3 >= media.spaceMedias.length) {
                        media.loadMore();
                      }
                    },
                    child: ImageCard(
                      index: index,
                      spaceMedia: media.spaceMedias[index],
                    ),
                  );
                },
                childCount: media.spaceMedias.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
