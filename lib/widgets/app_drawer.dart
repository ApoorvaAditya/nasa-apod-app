import 'package:flutter/material.dart';
import 'package:nasa_apod_app/screens/saved_screen.dart';
import 'package:nasa_apod_app/screens/settings_screen.dart';

import '../constants.dart';
import '../screens/all_pictures_screen.dart';
import '../screens/details_screen.dart';
import '../screens/submit_screen.dart';
import '../screens/time_machine_screen.dart';
import 'background_gradient.dart';

class AppDrawer extends StatelessWidget {
  final String prevScreen;

  const AppDrawer({this.prevScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BackgroundGradient(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            DrawerHeaderImage(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: Icon(
                  Icons.today,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Astronomy Picture of the Day',
                  style: whiteTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailsScreen(),
                      settings: const RouteSettings(arguments: {}),
                    ),
                  );
                },
              ),
            ),
            DrawerListItem(
              icon: Icons.photo_library,
              title: 'All Pictures',
              prevScreen: prevScreen,
              routeName: AllPicturesScreeen.routeName,
            ),
            DrawerListItem(
              icon: Icons.timer,
              title: 'Time Machine',
              prevScreen: prevScreen,
              routeName: TimeMachineScreen.routeName,
            ),
            DrawerListItem(
              icon: Icons.file_upload,
              title: 'Submit your Picture to APOD',
              prevScreen: prevScreen,
              routeName: SubmitScreen.routeName,
            ),
            DrawerListItem(
              icon: Icons.bookmark,
              title: 'Saved Pictures',
              prevScreen: prevScreen,
              routeName: SavedScreen.routeName,
            ),
            DrawerListItem(
              icon: Icons.settings,
              title: 'Settings',
              prevScreen: prevScreen,
              routeName: SettingsScreen.routeName,
            ),
            const Spacer(),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: const Text(
                'About',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showAboutDialog(context: context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class DrawerHeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Image.asset(
          'assets/images/nasa-logo.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.network(
            'https://www.nasa.gov/sites/default/files/thumbnails/image/nasa-logo-web-rgb.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class DrawerListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String prevScreen;
  final String routeName;
  const DrawerListItem({
    Key key,
    this.icon,
    this.title,
    this.prevScreen,
    this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: whiteTextStyle,
        ),
        onTap: () {
          if (prevScreen == routeName) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushNamed(routeName);
          }
        },
      ),
    );
  }
}
