import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs extends ChangeNotifier {
  SharedPreferences _prefs;
  bool isLoading = true;
  // Settings
  String albumNameKey = 'albumName';

  Prefs() {
    _getInstance();
  }

  Future<void> _getInstance() async {
    isLoading = true;
    _prefs = await SharedPreferences.getInstance();
    isLoading = false;
    notifyListeners();
  }

  void setAlbumName(String value) {
    _prefs.setString(albumNameKey, value);
    notifyListeners();
  }

  String getAlbumName() {
    return _prefs.getString(albumNameKey);
  }
}
