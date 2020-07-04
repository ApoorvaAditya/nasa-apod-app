import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/all_pictures_screen.dart';
import 'screens/details_screen.dart';
import 'screens/past_pictures_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/submit_screen.dart';
import 'services/media.dart';
import 'services/prefs.dart';
import 'strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDirectory = await getApplicationDocumentsDirectory();
  Hive.init(applicationDirectory.path);
  runApp(MyApp());
}

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
            PastPicturesScreen.routeName: (_) => PastPicturesScreen(),
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
