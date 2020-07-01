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
                  SettingsListTile(
                    controller: _albumController,
                    title: 'Album Name',
                    value: prefs.getAlbumName(),
                    subtitle: 'Name of album where downloaded pictures will be stored.',
                    hint: 'Enter album name',
                    onSubmitted: (value) {
                      prefs.setAlbumName(value);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String subtitle;
  final String hint;
  final String value;
  final void Function(String value) onSubmitted;

  const SettingsListTile({
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
        style: const TextStyle(
          color: Colors.white,
        ),
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
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
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
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
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
