import 'package:flutter/material.dart';
import 'package:nasa_apod_app/screens/saved_screen.dart';
import 'package:nasa_apod_app/services/prefs.dart';
import 'package:provider/provider.dart';

import 'screens/all_pictures_screen.dart';
import 'screens/details_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/submit_screen.dart';
import 'screens/time_machine_screen.dart';
import 'services/media.dart';
import 'strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Title(
      title: Strings.appTitle,
      color: Colors.white,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<Media>(create: (_) => Media()),
          ChangeNotifierProvider<Prefs>(create: (_) => Prefs()),
        ],
        child: MaterialApp(
          title: Strings.appTitle,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            primaryColor: Colors.black,
            primaryColorBrightness: Brightness.dark,
            accentColor: Colors.white,
            accentColorBrightness: Brightness.light,
            primaryTextTheme: const TextTheme(
              bodyText1: TextStyle(
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: AllPicturesScreeen.routeName,
          routes: {
            AllPicturesScreeen.routeName: (_) => AllPicturesScreeen(),
            TimeMachineScreen.routeName: (_) => TimeMachineScreen(),
            SubmitScreen.routeName: (_) => SubmitScreen(),
            DetailsScreen.routeName: (_) => DetailsScreen(),
            SavedScreen.routeName: (_) => SavedScreen(),
            SettingsScreen.routeName: (_) => SettingsScreen(),
          },
        ),
      ),
    );
  }
}
