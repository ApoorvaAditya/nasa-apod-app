import 'package:flutter/material.dart';
import 'package:nasa_apod_app/widgets/app_drawer.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';

class SavedScreen extends StatelessWidget {
  static const routeName = '/saved';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        prevScreen: routeName,
      ),
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: BackgroundGradient(),
    );
  }
}
