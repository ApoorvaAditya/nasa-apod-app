import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/space_media.dart';
import '../utils.dart';
import 'get_apod.dart';

class Media with ChangeNotifier {
  // Is the media loading data from source? Used to prevent loading if already loading
  bool _isLoading = false;
  // List of all the SpaceMedia associated
  List<SpaceMedia> _spaceMedias = <SpaceMedia>[];

  DateTime _today;
  DateTime mainDate;

  int aheadIndex;
  int behindIndex;
  bool loadAhead;
  bool loadBehind;
  final int lengthToLoad;
  final int initialIndex;

  // SpaceMedias getter
  List<SpaceMedia> get spaceMedias {
    return [..._spaceMedias];
  }

  // Constructor
  Media({
    this.initialIndex = 0,
    this.lengthToLoad = 1,
    this.loadAhead = false,
    this.loadBehind = true,
    this.mainDate,
  }) {
    refresh();
  }

  Future<void> refresh() async {
    await clearCachedData();
    loadMore();
  }

  Future<void> loadMore() async {
    if (_isLoading) {
      return Future.value();
    }
    _isLoading = true;
    // ignore: avoid_print
    print('loading');
    return _getAPODs().then((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _getAPODs() async {
    if (loadAhead) {
      for (int i = aheadIndex + 1; i > aheadIndex + lengthToLoad; i++) {
        final DateTime currentDate = mainDate.add(Duration(days: i));
        // Get APOD for later days
        if (currentDate.isBefore(_today)) {
          final SpaceMedia spaceMedia = await getAPOD(date: currentDate);
          if (spaceMedia != null) _spaceMedias.insert(0, spaceMedia);
          notifyListeners();
        } else {
          loadAhead = false;
        }
      }
    }
    if (loadBehind) {
      for (int i = behindIndex; i < behindIndex + lengthToLoad; i++) {
        final DateTime currentDate = mainDate.subtract(Duration(days: i));

        if (currentDate.isAfter(earliestPossibleDate)) {
          // Get APOD for the previous days
          final SpaceMedia spaceMedia = await getAPOD(date: currentDate);

          behindIndex += lengthToLoad;
          if (spaceMedia != null) _spaceMedias.add(spaceMedia);
          notifyListeners();
        } else {
          loadBehind = false;
        }
      }
    }
  }

  Future<void> clearCachedData() async {
    // Get today's date
    final DateTime latestDate = await Utils.getLatesetPostDate();
    _today = latestDate ?? DateTime.now().subtract(const Duration(days: 1));
    mainDate ??= _today;
    _spaceMedias = <SpaceMedia>[];
    aheadIndex = initialIndex;
    behindIndex = initialIndex;
    loadAhead = true;
    loadBehind = true;
    notifyListeners();
  }
}
