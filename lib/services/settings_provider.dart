import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nasa_apod_app/utils.dart';

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

class SettingsProvider with ChangeNotifier {
  static const String settingsBoxName = 'settings';

  String albumNameKey = 'albumName';
  String downloadOnSaveKey = 'downloadOnSave';
  String downloadHq = 'downloadHq';
  String wallpaperCropMethod = 'wallpaperCropMethod';
  String automaticWallpapers = 'automaticWallpapers';
  String defaultWallpaperScreen = 'defaultWallpaperScreen';
  String dailyNotifications = 'dailyNotifications';
  String fontSize = 'fontSize';
  String latestDate = 'latestDate';

  late Box _box;

  SettingsProvider() {
    _box = Hive.box(settingsBoxName);
    initializeValues();
  }

  void initializeValues() {
    if (!_box.containsKey(albumNameKey)) {
      setAlbumName(value: 'Astronomy Pictures');
    }
    if (!_box.containsKey(downloadOnSaveKey)) {
      setDownloadOnSave(value: false);
    }
    if (!_box.containsKey(downloadHq)) {
      setDownloadHq(value: false);
    }
    if (!_box.containsKey(wallpaperCropMethod)) {
      setWallpaperCropMethod(value: WallpaperCropMethod.alwaysFit);
    }
    if (!_box.containsKey(automaticWallpapers)) {
      setAutomaticWallpaper(value: false);
    }
    if (!_box.containsKey(defaultWallpaperScreen)) {
      setDefaultWallpaperScreen(value: DefaultWallpaperScreen.alwaysAsk);
    }
    if (!_box.containsKey(dailyNotifications)) {
      setDailyNotifications(value: true);
    }
    if (!_box.containsKey(fontSize)) {
      setFontSize(value: 16.0);
    }
    if (!_box.containsKey(latestDate)) {
      Utils.getLatesetPostDate.then((value) => setLatestDate(value: value!));
    }
  }

  void setAlbumName({required String value}) {
    _box.put(albumNameKey, value);
    notifyListeners();
  }

  void setDownloadOnSave({required bool value}) {
    _box.put(downloadOnSaveKey, value);
    notifyListeners();
  }

  void setDownloadHq({required bool value}) {
    _box.put(downloadHq, value);
    notifyListeners();
  }

  void setWallpaperCropMethod({required WallpaperCropMethod value}) {
    _box.put(wallpaperCropMethod, value.index);
    notifyListeners();
  }

  void setAutomaticWallpaper({required bool value}) {
    _box.put(automaticWallpapers, value);
    notifyListeners();
  }

  void setDefaultWallpaperScreen({required DefaultWallpaperScreen value}) {
    _box.put(defaultWallpaperScreen, value.index);
    notifyListeners();
  }

  void setDailyNotifications({required bool value}) {
    _box.put(dailyNotifications, value);
    notifyListeners();
  }

  void setFontSize({required double value}) {
    _box.put(fontSize, value);
    notifyListeners();
  }

  void setLatestDate({required DateTime value}) {
    _box.put(latestDate, value);
  }

  bool getDownloadOnSave() => _box.get(downloadOnSaveKey) as bool;

  bool getDownloadHq() => _box.get(downloadHq) as bool;

  String getAlbumName() => _box.get(albumNameKey) as String;

  WallpaperCropMethod getWallpaperCropMethod() => WallpaperCropMethod.values[_box.get(wallpaperCropMethod) as int];

  int getWallpaperCropMethodIndex() => _box.get(wallpaperCropMethod) as int;

  bool getAutomaticWallpapers() => _box.get(automaticWallpapers) as bool;

  int getDefaultWallpaperScreenIndex() => _box.get(defaultWallpaperScreen) as int;

  DefaultWallpaperScreen getDefaultWallpaperScreen() =>
      DefaultWallpaperScreen.values[_box.get(defaultWallpaperScreen) as int];

  bool getDailyNotifications() => _box.get(dailyNotifications) as bool;

  double getFontSize() => _box.get(fontSize) as double;

  DateTime getLatestDate() => _box.get(latestDate) as DateTime;
}
