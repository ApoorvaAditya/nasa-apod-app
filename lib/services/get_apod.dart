import 'package:date_format/date_format.dart' show formatDate, yy, mm, dd;
import 'package:html/parser.dart';
import 'package:http/http.dart' show Response, get;

import '../models/space_media.dart';
import '../utils.dart';

Future<SpaceMedia> getAPOD({DateTime date}) async {
  String type, url, hdImageUrl, title, credits, description;

  // Convert date to correct format for url
  final String dateString = formatDate(date, [yy, mm, dd]);

  // Get page and parse it
  final Response response = await get('https://apod.nasa.gov/apod/ap$dateString.html');
  final document = parse(response.body);

  // If encounter error, return null
  if (response.statusCode >= 400) return null;

  final imageHtmlList = document.getElementsByTagName('img');
  final videoHtmlList = document.getElementsByTagName('iframe');

  // Check for images and if find it, store it's information
  if (imageHtmlList != null && imageHtmlList.isNotEmpty) {
    type = 'image';
    url = 'https://apod.nasa.gov/apod/${imageHtmlList[0].attributes['src']}';
    hdImageUrl = 'https://apod.nasa.gov/apod/${document.getElementsByTagName('a')[1].attributes['href']}';
  }

  // Check for videos and if find it, store it's information
  else if (videoHtmlList != null && videoHtmlList.isNotEmpty) {
    url = Utils.convertYoutbeEmbedToLink(videoHtmlList[0].attributes['src']);
    type = 'video';
  }

  // Get title and credits
  final List centerList = document.getElementsByTagName('center');
  if (centerList != null && centerList.isNotEmpty) {
    title = document.getElementsByTagName('center')[1].children[0].innerHtml.trim();
    credits = document.getElementsByTagName('center')[1].innerHtml;
  }

  // Get description
  final List paraList = document.getElementsByTagName('p');
  if (paraList != null && paraList.isNotEmpty) {
    description =
        Utils.removeNewLinesAndExtraSpace(document.getElementsByTagName('p')[2].innerHtml.substring(24).trim());
  }

  return SpaceMedia(
    date: date,
    copyright: credits,
    description: description,
    title: title,
    type: type,
    url: url,
    hdImageUrl: hdImageUrl,
  );
}
