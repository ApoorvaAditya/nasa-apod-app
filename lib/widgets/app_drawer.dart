import 'package:flutter/material.dart';
import 'package:nasa_apod_app/constants.dart';
import 'package:nasa_apod_app/screens/all_pictures_screen.dart';
import 'package:nasa_apod_app/screens/past_pictures_screen.dart';
import 'package:nasa_apod_app/screens/saved_screen.dart';
import 'package:nasa_apod_app/screens/settings_screen.dart';
import 'package:nasa_apod_app/screens/submit_screen.dart';
import 'package:nasa_apod_app/strings.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';

class AppDrawer extends StatelessWidget {
  final String? prevScreen;

  const AppDrawer({this.prevScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BackgroundGradient(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            DrawerHeaderImage(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Text(
                'Astronomy Picture of the Day',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DrawerListItem(
              icon: Icons.photo_library,
              title: Strings.allPicturesScreenTitle,
              prevScreen: prevScreen,
              routeName: AllPicturesScreeen.routeName,
            ),
            DrawerListItem(
              icon: Icons.calendar_today,
              title: Strings.pastPicturesScreenTitle,
              prevScreen: prevScreen,
              routeName: PastPicturesScreen.routeName,
            ),
            DrawerListItem(
              icon: Icons.file_upload,
              title: Strings.submitScreenTitle,
              prevScreen: prevScreen,
              routeName: SubmitScreen.routeName,
            ),
            DrawerListItem(
              icon: Icons.bookmark,
              title: Strings.savedScreenTitle,
              prevScreen: prevScreen,
              routeName: SavedScreen.routeName,
            ),
            DrawerListItem(
              icon: Icons.settings,
              title: Strings.settingsScreenTitle,
              prevScreen: prevScreen,
              routeName: SettingsScreen.routeName,
            ),
            const Spacer(),
            const Divider(
              color: Colors.black,
              height: 0,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: const Text(
                'About',
                style: whiteTextStyle,
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/icon/icon_small.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                  applicationName: 'Astronomy Picture of the Day',
                  applicationVersion: '1.1.0',
                  applicationLegalese: 'See, save, and learn about awe-inspiring and beautiful space pictures',
                );
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
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Image.asset(
          'assets/icon/icon_small.png',
          fit: BoxFit.contain,
          height: 150,
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
  final String? prevScreen;
  final String? routeName;
  const DrawerListItem({
    super.key,
    required this.icon,
    required this.title,
    this.prevScreen,
    this.routeName,
  });

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
            Navigator.of(context).pushReplacementNamed(routeName!);
          }
        },
      ),
    );
  }
}
