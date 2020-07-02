import 'package:flutter/material.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../services/prefs.dart';
import '../strings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';

Future<String> getAlbumName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('albumName');
}

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  final TextEditingController _albumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<Prefs>(context);
    return Scaffold(
      drawer: const AppDrawer(
        prevScreen: routeName,
      ),
      appBar: AppBar(
        title: const Text(Strings.settingsScreenTitle),
      ),
      body: BackgroundGradient(
        child: prefs.isLoading
            ? const CenteredCircularProgressIndicator()
            : ListView(
                children: <Widget>[
                  TextSettingsListTile(
                    controller: _albumController,
                    title: Strings.albumNameSettingTitle,
                    value: prefs.getAlbumName(),
                    subtitle: Strings.albumNameSettingSubtitle,
                    hint: Strings.albumNameSettingHint,
                    onSubmitted: (value) {
                      prefs.setAlbumName(value: value);
                    },
                  ),
                  SwitchSettingsListTile(
                    title: Strings.downloadOnSaveSettingTitle,
                    subtitle: Strings.downloadOnSaveSettingSubtitle,
                    value: prefs.getDownloadOnSave(),
                    onChanged: (value) {
                      prefs.setDownloadOnSave(value: value);
                    },
                  ),
                  SwitchSettingsListTile(
                    title: Strings.downloadHqSettingTitle,
                    subtitle: Strings.downloadHqSettingSubtitle,
                    enabled: prefs.getDownloadOnSave(),
                    value: prefs.getDownloadHq(),
                    onChanged: (value) {
                      if (prefs.getDownloadOnSave()) {
                        prefs.setDownloadHq(value: value);
                      }
                    },
                  ),
                ],
              ),
      ),
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
            child: Wrap(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
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
    return TextField(
      controller: controller,
      style: whiteTextStyle,
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
