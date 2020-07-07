import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/space_media.dart';
import '../utils.dart';

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
    final String spaceMediaKey = spaceMedia.date.toString();
    if (!_box.containsKey(spaceMediaKey)) {
      spaceMedias.add(spaceMedia);
      dates.add(spaceMedia.date);
      _box.put(spaceMediaKey, spaceMedia);
      _box.put(dateListKey, dates);
    }
    notifyListeners();
  }

  void removeSpaceMedia({@required SpaceMedia spaceMedia, BuildContext context}) {
    if (context != null) {
      Navigator.of(context).pop();
    }
    final String spaceMediaKey = spaceMedia.date.toString();
    if (_box.containsKey(spaceMediaKey)) {
      spaceMedias.removeWhere((element) => element.date == spaceMedia.date);
      dates.removeWhere((element) => element == spaceMedia.date);
      _box.delete(spaceMediaKey);
      _box.put(dateListKey, dates);
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

  Future<void> saveSpaceMediaImage(SpaceMedia spaceMedia) async {
    final http.Response response = await http.get(spaceMedia.hdImageUrl ?? spaceMedia.url);
    final String path = await Utils.localPath;
    File('$path/${spaceMedia.date.toString()}.png').writeAsBytes(response.bodyBytes);
  }

  Future<Uint8List> getSpaceMediaImage(SpaceMedia spaceMedia) async {
    final String path = await Utils.localPath;
    return File('$path/${spaceMedia.date.toString()}.png').readAsBytes();
  }

  Future<Uint8List> getSpaceMediaImageFromDate(DateTime date) async {
    final String path = await Utils.localPath;
    return File('$path/${date.toString()}.png').readAsBytes();
  }

  Future<void> deleteSpaceMediaImage(SpaceMedia spaceMedia) async {
    final String path = await Utils.localPath;
    File('$path/${spaceMedia.date.toString()}.png').delete();
  }

  Future<void> deleteSpaceMediaImageFromDate(DateTime date) async {
    final String path = await Utils.localPath;
    File('$path/${date.toString()}.png').delete();
  }
}
