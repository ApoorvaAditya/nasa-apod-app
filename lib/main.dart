import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/all_pictures_screen.dart';
import 'screens/details_screen.dart';
import 'screens/submit_screen.dart';
import 'screens/time_machine_screen.dart';
import 'services/media.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Media(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: Colors.black,
          primaryColorBrightness: Brightness.dark,
          accentColor: Colors.white,
          accentColorBrightness: Brightness.light,
          primaryTextTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AllPicturesScreeen.routeName,
        routes: {
          AllPicturesScreeen.routeName: (_) => AllPicturesScreeen(),
          TimeMachineScreen.routeName: (_) => TimeMachineScreen(),
          SubmitScreen.routeName: (_) => SubmitScreen(),
          DetailsScreen.routeName: (_) => DetailsScreen(),
        },
      ),
    );
  }
}
