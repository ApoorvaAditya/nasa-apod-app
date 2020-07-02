import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../services/prefs.dart';
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
        title: const Text('Settings'),
      ),
      body: BackgroundGradient(
        child: prefs.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  TextSettingsListTile(
                    controller: _albumController,
                    title: 'Album Name',
                    value: prefs.getAlbumName(),
                    subtitle: 'Name of album where downloaded pictures will be stored.',
                    hint: 'Enter album name',
                    onSubmitted: (value) {
                      prefs.setAlbumName(value: value);
                    },
                  ),
                  SwitchSettingsListTile(
                    title: 'Download Images on Save',
                    subtitle: 'Should Images be downloaded when saving pictures?',
                    value: prefs.getDownloadOnSave(),
                    onChanged: (value) {
                      prefs.setDownloadOnSave(value: value);
                    },
                  )
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
  final void Function(bool value) onChanged;

  const SwitchSettingsListTile({
    Key key,
    this.title,
    this.subtitle,
    this.onChanged,
    this.value,
  }) : super(key: key);

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
      trailing: Switch(
        activeColor: Colors.indigo[500],
        inactiveTrackColor: Colors.grey[700],
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
