import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WallpaperCropMethod {
  fillWholeScreen,
  alwaysFitHeight,
  alwaysFitWidth,
  alwaysFit,
}

enum DefaultWallpaperScreen {
  alwaysAsk,
  homeScreen,
  lockScreen,
  bothScreens,
}

class Prefs extends ChangeNotifier {
  SharedPreferences _prefs;
  bool isLoading = true;
  // Settings
  String albumNameKey = 'albumName';
  String downloadOnSaveKey = 'downloadOnSave';
  String downloadHq = 'downloadHq';
  String wallpaperCropMethod = 'wallpaperCropMethod';
  String automaticWallpapers = 'automaticWallpapers';
  String defaultWallpaperScreen = 'defaultWallpaperScreen';

  Prefs() {
    _getInstance();
  }

  Future<void> _getInstance() async {
    isLoading = true;
    _prefs = await SharedPreferences.getInstance();
    isLoading = false;
    initializeValues();
    notifyListeners();
  }

  void initializeValues() {
    if (!_prefs.containsKey(albumNameKey)) {
      setAlbumName(value: 'Astronomy Pictures');
    }
    if (!_prefs.containsKey(downloadOnSaveKey)) {
      setDownloadOnSave(value: false);
    }
    if (!_prefs.containsKey(downloadHq)) {
      setDownloadHq(value: false);
    }
    if (!_prefs.containsKey(wallpaperCropMethod)) {
      setWallpaperCropMethod(value: WallpaperCropMethod.alwaysFit);
    }
    if (!_prefs.containsKey(automaticWallpapers)) {
      setAutomaticWallpaper(value: false);
    }
    if (!_prefs.containsKey(defaultWallpaperScreen)) {
      setDefaultWallpaperScreen(value: DefaultWallpaperScreen.alwaysAsk);
    }
  }

  void setAlbumName({@required String value}) {
    _prefs.setString(albumNameKey, value);
    notifyListeners();
  }

  void setDownloadOnSave({@required bool value}) {
    _prefs.setBool(downloadOnSaveKey, value);
    notifyListeners();
  }

  void setDownloadHq({@required bool value}) {
    _prefs.setBool(downloadHq, value);
    notifyListeners();
  }

  void setWallpaperCropMethod({WallpaperCropMethod value}) {
    _prefs.setInt(wallpaperCropMethod, value.index);
    notifyListeners();
  }

  void setAutomaticWallpaper({bool value}) {
    _prefs.setBool(automaticWallpapers, value);
    notifyListeners();
  }

  void setDefaultWallpaperScreen({DefaultWallpaperScreen value}) {
    _prefs.setInt(defaultWallpaperScreen, value.index);
    notifyListeners();
  }

  bool getDownloadOnSave() => _prefs.getBool(downloadOnSaveKey);

  bool getDownloadHq() => _prefs.getBool(downloadHq);

  String getAlbumName() => _prefs.getString(albumNameKey);

  WallpaperCropMethod getWallpaperCropMethod() => WallpaperCropMethod.values[_prefs.getInt(wallpaperCropMethod)];

  int getWallpaperCropMethodIndex() => _prefs.getInt(wallpaperCropMethod);

  bool getAutomaticWallpapers() => _prefs.getBool(automaticWallpapers);

  int getDefaultWallpaperScreenIndex() => _prefs.getInt(defaultWallpaperScreen);

  DefaultWallpaperScreen getDefaultWallpaperScreen() =>
      DefaultWallpaperScreen.values[_prefs.getInt(defaultWallpaperScreen)];
}
