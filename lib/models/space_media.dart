import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'space_media.freezed.dart';
part 'space_media.g.dart';

@HiveType(typeId: 0)
@freezed
class SpaceMedia with _$SpaceMedia {
  factory SpaceMedia({
    @HiveField(0) required DateTime date,
    @HiveField(1) required String type,
    @HiveField(2) required String url,
    @HiveField(3) String? hdImageUrl,
    @HiveField(4) required String description,
    @HiveField(5) required String title,
    @HiveField(6) String? credits,
  }) = _SpaceMedia;

  factory SpaceMedia.fromJson(Map<String, dynamic> json) => _$SpaceMediaFromJson(json);
}
