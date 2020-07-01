import 'package:meta/meta.dart' show required;

class SpaceMedia {
  final DateTime date;
  final String type;
  final String url;
  final String hdImageUrl;
  final String description;
  final String title;
  final String credits;

  SpaceMedia({
    @required this.date,
    @required this.type,
    @required this.url,
    @required this.description,
    @required this.title,
    @required this.credits,
    this.hdImageUrl,
  });
}
