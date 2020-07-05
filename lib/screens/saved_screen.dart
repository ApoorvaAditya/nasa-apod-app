import 'package:flutter/material.dart';
import 'package:nasa_apod_app/widgets/image_card.dart';
import 'package:provider/provider.dart';

import '../services/hive_provider.dart';
import '../strings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';

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
                    spaceMedia: savedProvider.savedList[index],
                  );
                },
                childCount: savedProvider.savedList.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savedProvider.clear,
      ),
    );
  }
}
