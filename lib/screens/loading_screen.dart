import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../models/space_media.dart';
import '../services/saved_provider.dart';
import '../services/settings_provider.dart';
import '../widgets/background_gradient.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import 'all_pictures_screen.dart';

class LoadingScreen extends StatelessWidget {
  static const routeName = '/loading';

  Future<void> initializePrefsAndHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SpaceMediaAdapter());
    await Hive.openBox(SavedProvider.savedBoxName);
    await Hive.openBox(SettingsProvider.settingsBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializePrefsAndHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AllPicturesScreeen.routeName);
          });
        }
        return Scaffold(
          body: BackgroundGradient(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CenteredCircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading',
                  style: whiteTextStyle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
