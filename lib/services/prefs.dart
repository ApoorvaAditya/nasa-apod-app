import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs extends ChangeNotifier {
  SharedPreferences _prefs;
  bool isLoading = true;
  // Settings
  String albumNameKey = 'albumName';
  String downloadOnSaveKey = 'downloadOnSave';

  Prefs() {
    _getInstance();
  }

  Future<void> _getInstance() async {
    isLoading = true;
    _prefs = await SharedPreferences.getInstance();
    isLoading = false;
    if (!_prefs.containsKey(albumNameKey)) {
      setAlbumName(value: 'Astronomy Pictures');
    }
    if (!_prefs.containsKey(downloadOnSaveKey)) {
      setDownloadOnSave(value: false);
    }
    notifyListeners();
  }

  void setAlbumName({@required String value}) {
    _prefs.setString(albumNameKey, value);
    notifyListeners();
  }

  String getAlbumName() {
    return _prefs.getString(albumNameKey);
  }

  void setDownloadOnSave({@required bool value}) {
    _prefs.setBool(downloadOnSaveKey, value);
    notifyListeners();
  }

  bool getDownloadOnSave() {
    return _prefs.getBool(downloadOnSaveKey);
  }
}
