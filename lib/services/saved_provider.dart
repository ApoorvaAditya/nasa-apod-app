import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/space_media.dart';

class SavedProvider with ChangeNotifier {
  static const String savedBoxName = 'saved';
  String dateListKey = 'dateList';
  List dates;
  List spaceMedias = [];
  Box _box;

  SavedProvider() {
    _box = Hive.box(savedBoxName);
    initializeValues();
    notifyListeners();
  }

  void initializeValues() {
    if (_box.containsKey(dateListKey)) {
      dates = _box.get(dateListKey) as List;
    } else {
      dates = [];
      _box.put(dateListKey, []);
    }
    if (_box.keys.length > 1) {
      for (final date in dates) {
        spaceMedias.add(_box.get(date.toString()));
      }
    }
  }

  void addSpaceMedia(SpaceMedia spaceMedia) {
    print('adding: ${spaceMedia.date.toString()}');
    final String spaceMediaKey = spaceMedia.date.toString();
    if (!_box.containsKey(spaceMediaKey)) {
      spaceMedias.add(spaceMedia);
      dates.add(spaceMedia.date);
      _box.put(spaceMediaKey, spaceMedia);
    }
    notifyListeners();
  }

  void removeSpaceMedia({
    @required SpaceMedia spaceMedia,
    @required BuildContext context,
  }) {
    print('deleting: ${spaceMedia.date.toString()}');

    Navigator.of(context).pop();
    final String spaceMediaKey = spaceMedia.date.toString();
    if (_box.containsKey(spaceMediaKey)) {
      spaceMedias.removeWhere((element) => element.date == spaceMedia.date);
      dates.removeWhere((element) => element == spaceMedia.date);
      _box.delete(spaceMediaKey);
    }
    notifyListeners();
  }

  void removeSpaceMediaWithDate(DateTime date) {
    final String spaceMediaKey = date.toString();
    if (_box.containsKey(spaceMediaKey)) {
      spaceMedias.removeWhere((element) => element.date == date);
      dates.removeWhere((element) => element == date);
      _box.delete(spaceMediaKey);
    }
  }
}
