import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/space_media.dart';

class SavedProvider with ChangeNotifier {
  String boxName = 'saved';
  String datesListKey = 'dateList';

  List dateList;
  List<SpaceMedia> savedList;

  Box box;
  bool isLoading;

  SavedProvider() {
    openBox();
  }

  void openBox() {
    print('initializing');
    isLoading = true;
    if (!box.containsKey(datesListKey)) {
      box.put(datesListKey, []);
      dateList = [];
    }
    dateList = box.get(datesListKey) as List;
    if (box.length <= 1) {
      savedList = [];
    } else {
      savedList = getSpaceMediaList();
    }
    isLoading = false;
  }

  List<SpaceMedia> getSpaceMediaList() {
    final List<SpaceMedia> spaceMedias = [];
    for (int i = 0; i < dateList.length; i++) {
      final date = dateList[i];
      spaceMedias.add(box.get(date.toIso8601String()) as SpaceMedia);
    }
    return spaceMedias;
  }

  void addSpaceMedia(SpaceMedia spaceMedia) {
    if (!box.keys.contains(spaceMedia.date.toIso8601String())) {
      print('adding: ${spaceMedia.title}');
      box.put(spaceMedia.date.toIso8601String(), spaceMedia);
      savedList.add(spaceMedia);
      notifyListeners();
    }
  }

  void removeSpaceMedia(DateTime date) {
    print('deleting');
    if (box.containsKey(date.toIso8601String())) {
      box.delete(date.toIso8601String());
      savedList.removeWhere((spaceMedia) => spaceMedia.date.toIso8601String() == date.toIso8601String());
      notifyListeners();
    }
  }

  void clear() {
    print('yeet');
    for (var i = 0; i < dateList.length; i++) {
      print('yeets');
      removeSpaceMedia(dateList[i] as DateTime);
    }
  }
}
