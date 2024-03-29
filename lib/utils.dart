import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' show Response, get;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: avoid_classes_with_only_static_members
class Utils {
  static String removeNewLinesAndExtraSpace(String text) {
    return text.replaceAll('\n', ' ').replaceAll(RegExp(r'\s{2,}'), ' ');
  }

  static String convertYoutbeEmbedToLink(String url) {
    String thumbnailUrl;
    thumbnailUrl = url.replaceFirst('embed/', 'watch?v=');
    if (url.contains('?rel=0')) {
      thumbnailUrl = thumbnailUrl.replaceFirst('?rel=0', '');
    }
    return thumbnailUrl;
  }

  static String getYtThumbnailLink(String url) {
    final String id = url.split('=')[1];
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<DateTime?> get getLatesetPostDate async {
    final Response repsonse = await get(Uri.parse('https://apod.nasa.gov/apod/astropix.html'));
    if (repsonse.statusCode >= 400) return null;
    final parsed = html.parse(repsonse.body);
    return DateTime.parse(convertDateToParsable(parsed.getElementsByTagName('p')[1].innerHtml.split('\n')[2]));
  }

  static double getHeightOfPage(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - mediaQuery.padding.top - kToolbarHeight;
  }

  static String convertDateToParsable(String date) {
    final List<String> parts = date.split(' ');
    final String year = parts[0];
    final String month = parts[1];
    final String day = parts[2].length < 2 ? '0${parts[2]}' : parts[2];
    return '$year-${monthToInt(month)}-$day';
  }

  static String monthToInt(String month) {
    switch (month) {
      case 'January':
        return '01';
      case 'February':
        return '02';
      case 'March':
        return '03';
      case 'April':
        return '04';
      case 'May':
        return '05';
      case 'June':
        return '06';
      case 'July':
        return '07';
      case 'August':
        return '08';
      case 'September':
        return '09';
      case 'October':
        return '10';
      case 'November':
        return '11';
      case 'December':
        return '12';
      default:
        return '01';
    }
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
