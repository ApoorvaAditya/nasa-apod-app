import 'package:flutter/material.dart';
import 'package:nasa_apod_app/widgets/app_drawer.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';

import '../strings.dart';

class SavedScreen extends StatelessWidget {
  static const routeName = '/saved';

  @override
  Widget build(BuildContext context) {
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
              delegate: SliverChildBuilderDelegate((_, index) {
                return Container(
                  color: Colors.indigo[(index % 10) * 100],
                  height: 20,
                  padding: const EdgeInsets.all(8),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
