import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:nasa_apod_app/constants.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/services/get_apod.dart';
import 'package:nasa_apod_app/utils.dart';

class Media with ChangeNotifier {
  bool _isLoading = false;
  List<SpaceMedia> _spaceMedias = <SpaceMedia>[];
  late DateTime _today;
  late int startIndex;

  final int initialIndex;
  final int lengthToLoad;

  // SpaceMedias getter
  List<SpaceMedia> get spaceMedias {
    return [..._spaceMedias];
  }

  // Constructor
  Media({
    this.initialIndex = 0,
    this.lengthToLoad = 1,
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
    return _getAPODs().then((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _getAPODs() async {
    final int fixedIndex = startIndex;
    for (int i = fixedIndex; i < fixedIndex + lengthToLoad; i++) {
      final DateTime currentDate = _today.subtract(Duration(days: i));

      if (currentDate.isAfter(earliestPossibleDate)) {
        SpaceMedia? spaceMedia;
        try {
          spaceMedia = await getAPOD(date: currentDate);
        } on SocketException {
          rethrow;
        }
        startIndex += lengthToLoad;
        if (spaceMedia != null) _spaceMedias.add(spaceMedia);
        notifyListeners();
      }
    }
  }

  Future<void> clearCachedData() async {
    // Get today's date
    final DateTime? latestDate = await Utils.getLatesetPostDate;
    _today = latestDate ?? DateTime.now().subtract(const Duration(days: 1));
    _spaceMedias = <SpaceMedia>[];
    startIndex = initialIndex;
    notifyListeners();
  }
}
