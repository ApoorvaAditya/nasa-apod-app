import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/settings_provider.dart';
import '../strings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  final TextEditingController _albumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(
        prevScreen: routeName,
      ),
      appBar: AppBar(
        title: const Text(Strings.settingsScreenTitle),
      ),
      body: BackgroundGradient(
        child: ListView(
          children: <Widget>[
            const SettingsGroupListTile(
              title: 'App Settings',
            ),
            const Divider(
              color: Colors.white,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            FontListTile(
              title: 'Font Size',
              selectedFontIndex: FontListTile.fontSizes.indexOf(settings.getFontSize()),
              onTap: (int index) {
                Navigator.of(context).pop();
                settings.setFontSize(value: FontListTile.fontSizes[index]);
              },
            ),
            const SettingsGroupListTile(
              title: 'Download Settings',
            ),
            const Divider(
              color: Colors.white,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            TextSettingsListTile(
              controller: _albumController,
              title: Strings.albumNameSettingTitle,
              value: settings.getAlbumName(),
              subtitle: Strings.albumNameSettingSubtitle,
              hint: Strings.albumNameSettingHint,
              onSubmitted: (value) {
                settings.setAlbumName(value: value);
              },
            ),
            // SwitchSettingsListTile(
            //   title: Strings.downloadOnSaveSettingTitle,
            //   subtitle: Strings.downloadOnSaveSettingSubtitle,
            //   value: settings.getDownloadOnSave(),
            //   onChanged: (value) {
            //     settings.setDownloadOnSave(value: value);
            //   },
            // ),
            // SwitchSettingsListTile(
            //   title: Strings.downloadHqSettingTitle,
            //   subtitle: Strings.downloadHqSettingSubtitle,
            //   enabled: settings.getDownloadOnSave(),
            //   value: settings.getDownloadHq(),
            //   onChanged: (value) {
            //     if (settings.getDownloadOnSave()) {
            //       settings.setDownloadHq(value: value);
            //     }
            //   },
            // ),
            const SettingsGroupListTile(
              title: 'Wallpaper Settings',
            ),
            const Divider(
              color: Colors.white,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 8),
            // SwitchSettingsListTile(
            //   value: settings.getAutomaticWallpapers(),
            //   title: 'Set Wallpapers Automatically',
            //   subtitle: 'Download latest image every day and set it as the wallpaper',
            //   onChanged: (value) {
            //     settings.setAutomaticWallpaper(value: value);
            //   },
            // ),
            ListSettingsListTile(
              title: 'Wallpaper Fit',
              subtitle: 'How wallpapers should fit on screen',
              index: settings.getWallpaperCropMethodIndex(),
              enumToStrings: const {
                WallpaperCropMethod.fillWholeScreen: 'Fill whole screen',
                WallpaperCropMethod.alwaysFitHeight: 'Always fit image vertically',
                WallpaperCropMethod.alwaysFitWidth: 'Always fit image horizontally',
                WallpaperCropMethod.alwaysFit: 'Always fit whole image',
              },
              icons: const [
                MdiIcons.arrowExpandAll,
                MdiIcons.arrowExpandVertical,
                MdiIcons.arrowExpandHorizontal,
                Icons.fullscreen,
              ],
              onTap: (index) {
                Navigator.of(context).pop();
                settings.setWallpaperCropMethod(value: WallpaperCropMethod.values[index]);
              },
            ),
            ListSettingsListTile(
              title: 'Default Screen(s) for Wallpapers',
              subtitle: 'Set which screen(s) to set wallpaper on when you click on the wallpaper button',
              index: settings.getDefaultWallpaperScreenIndex(),
              enumToStrings: const {
                DefaultWallpaperScreen.alwaysAsk: 'Always Ask',
                DefaultWallpaperScreen.homeScreen: 'Home Screen',
                DefaultWallpaperScreen.lockScreen: 'Lock Screen',
                DefaultWallpaperScreen.bothScreens: 'Both Screens',
              },
              icons: const [
                MdiIcons.commentQuestion,
                Icons.home,
                Icons.screen_lock_portrait,
                Icons.filter,
              ],
              onTap: (index) {
                Navigator.of(context).pop();
                settings.setDefaultWallpaperScreen(value: DefaultWallpaperScreen.values[index]);
              },
            ),
            const SettingsGroupListTile(
              title: 'Notification Settings',
            ),
            const Divider(
              color: Colors.white,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 8),
            SwitchSettingsListTile(
              title: 'Daily Notifications',
              subtitle: 'Send notification whenever new image is available?',
              value: settings.getDailyNotifications(),
              onChanged: (value) {
                settings.setDailyNotifications(value: value);
              },
            ),
            const SettingsGroupListTile(
              title: 'Other Settings',
            ),
            const Divider(
              color: Colors.white,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            ButtonListTile(
              title: 'Write a Review!',
              onTap: () {
                AppReview.storeListing;
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class FontListTile extends StatelessWidget {
  final String title;
  final int selectedFontIndex;
  final void Function(int index) onTap;
  static const List<double> fontSizes = [
    10,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
  ];

  const FontListTile({
    Key key,
    this.title,
    this.selectedFontIndex,
    this.onTap,
  }) : super(key: key);

  List<Widget> buildFontOfFontTiles() {
    final List<Widget> widgets = [];
    for (int i = 0; i < fontSizes.length; i++) {
      widgets.add(
        ListTileWithIndex(
          icons: null,
          index: i,
          title: fontSizes[i].toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSizes[i],
          ),
          onTap: onTap,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        fontSizes[selectedFontIndex].toString(),
        style: whiteTextStyle,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: darkBlue,
              border: Border(
                top: BorderSide(
                  color: Colors.white54,
                ),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ...buildFontOfFontTiles(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SettingsGroupListTile extends StatelessWidget {
  final String title;

  const SettingsGroupListTile({
    Key key,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}

class ListSettingsListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map enumToStrings;
  final int index;
  final List<IconData> icons;
  final void Function(int index) onTap;

  const ListSettingsListTile({
    Key key,
    this.title,
    this.subtitle,
    this.enumToStrings,
    this.index,
    this.icons,
    this.onTap,
  }) : super(key: key);

  List<Widget> buildOptionList() {
    final List<Widget> widgets = [];
    final List strings = enumToStrings.values.toList();
    for (var i = 0; i < enumToStrings.length; i++) {
      widgets.add(
        ListTileWithIndex(
          icons: icons,
          index: i,
          title: strings[i] as String,
          onTap: onTap,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Text(
          enumToStrings.values.toList()[index].toString(),
          textAlign: TextAlign.right,
          style: whiteTextStyle,
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: darkBlue,
              border: Border(
                top: BorderSide(
                  color: Colors.white54,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ...buildOptionList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ListTileWithIndex extends StatelessWidget {
  const ListTileWithIndex({
    Key key,
    @required this.icons,
    @required this.index,
    @required this.title,
    this.onTap,
    this.style,
  }) : super(key: key);

  final List<IconData> icons;
  final int index;
  final String title;
  final void Function(int index) onTap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icons != null
          ? Icon(
              icons[index],
              color: Colors.white,
            )
          : null,
      title: Text(
        title,
        style: style ?? whiteTextStyle,
      ),
      onTap: () {
        onTap(index);
      },
    );
  }
}

class SwitchSettingsListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final void Function(bool value) onChanged;

  const SwitchSettingsListTile({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.onChanged,
    @required this.value,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: enabled ? Colors.grey : Colors.grey[800],
        ),
      ),
      trailing: Switch(
        activeColor: enabled ? Colors.indigo[500] : const Color.fromRGBO(0, 24, 85, 1),
        inactiveThumbColor: enabled ? Colors.white : Colors.grey,
        inactiveTrackColor: enabled ? Colors.grey[700] : Colors.grey[900],
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class TextSettingsListTile extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String subtitle;
  final String hint;
  final String value;
  final void Function(String value) onSubmitted;

  const TextSettingsListTile({
    Key key,
    this.controller,
    this.title,
    this.subtitle,
    this.hint,
    this.value,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        value,
        style: whiteTextStyle,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: darkBlue,
              border: Border(
                top: BorderSide(
                  color: Colors.white54,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                BottomSheetTextField(
                  controller: controller,
                  label: title,
                  hint: hint,
                  onSubmited: onSubmitted,
                ),
              ],
            ),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
        );
      },
    );
  }
}

class ButtonListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function() onTap;

  const ButtonListTile({
    Key key,
    this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: whiteTextStyle,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

class BottomSheetTextField extends StatelessWidget {
  const BottomSheetTextField({
    Key key,
    @required this.label,
    @required this.controller,
    this.hint,
    this.onSubmited,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final void Function(String value) onSubmited;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextField(
        controller: controller,
        style: whiteTextStyle,
        autofocus: true,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: whiteTextStyle,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white30,
          ),
          focusedBorder: buildWhiteOutlineBorder(),
          enabledBorder: buildWhiteOutlineBorder(),
          errorBorder: buildErrorOutlineInputBorder(context),
          focusedErrorBorder: buildErrorOutlineInputBorder(context),
        ),
        autocorrect: false,
        onSubmitted: onSubmited,
      ),
    );
  }
}

OutlineInputBorder buildWhiteOutlineBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  );
}

OutlineInputBorder buildErrorOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Theme.of(context).errorColor,
    ),
  );
}
