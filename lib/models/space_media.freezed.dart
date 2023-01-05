// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpaceMedia _$SpaceMediaFromJson(Map<String, dynamic> json) {
  return _SpaceMedia.fromJson(json);
}

/// @nodoc
mixin _$SpaceMedia {
  @HiveField(0)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(1)
  String get type => throw _privateConstructorUsedError;
  @HiveField(2)
  String get url => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get hdImageUrl => throw _privateConstructorUsedError;
  @HiveField(4)
  String get description => throw _privateConstructorUsedError;
  @HiveField(5)
  String get title => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get credits => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpaceMediaCopyWith<SpaceMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceMediaCopyWith<$Res> {
  factory $SpaceMediaCopyWith(
          SpaceMedia value, $Res Function(SpaceMedia) then) =
      _$SpaceMediaCopyWithImpl<$Res, SpaceMedia>;
  @useResult
  $Res call(
      {@HiveField(0) DateTime date,
      @HiveField(1) String type,
      @HiveField(2) String url,
      @HiveField(3) String? hdImageUrl,
      @HiveField(4) String description,
      @HiveField(5) String title,
      @HiveField(6) String? credits});
}

/// @nodoc
class _$SpaceMediaCopyWithImpl<$Res, $Val extends SpaceMedia>
    implements $SpaceMediaCopyWith<$Res> {
  _$SpaceMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? type = null,
    Object? url = null,
    Object? hdImageUrl = freezed,
    Object? description = null,
    Object? title = null,
    Object? credits = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      hdImageUrl: freezed == hdImageUrl
          ? _value.hdImageUrl
          : hdImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      credits: freezed == credits
          ? _value.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SpaceMediaCopyWith<$Res>
    implements $SpaceMediaCopyWith<$Res> {
  factory _$$_SpaceMediaCopyWith(
          _$_SpaceMedia value, $Res Function(_$_SpaceMedia) then) =
      __$$_SpaceMediaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) DateTime date,
      @HiveField(1) String type,
      @HiveField(2) String url,
      @HiveField(3) String? hdImageUrl,
      @HiveField(4) String description,
      @HiveField(5) String title,
      @HiveField(6) String? credits});
}

/// @nodoc
class __$$_SpaceMediaCopyWithImpl<$Res>
    extends _$SpaceMediaCopyWithImpl<$Res, _$_SpaceMedia>
    implements _$$_SpaceMediaCopyWith<$Res> {
  __$$_SpaceMediaCopyWithImpl(
      _$_SpaceMedia _value, $Res Function(_$_SpaceMedia) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? type = null,
    Object? url = null,
    Object? hdImageUrl = freezed,
    Object? description = null,
    Object? title = null,
    Object? credits = freezed,
  }) {
    return _then(_$_SpaceMedia(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      hdImageUrl: freezed == hdImageUrl
          ? _value.hdImageUrl
          : hdImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      credits: freezed == credits
          ? _value.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SpaceMedia implements _SpaceMedia {
  _$_SpaceMedia(
      {@HiveField(0) required this.date,
      @HiveField(1) required this.type,
      @HiveField(2) required this.url,
      @HiveField(3) this.hdImageUrl,
      @HiveField(4) required this.description,
      @HiveField(5) required this.title,
      @HiveField(6) this.credits});

  factory _$_SpaceMedia.fromJson(Map<String, dynamic> json) =>
      _$$_SpaceMediaFromJson(json);

  @override
  @HiveField(0)
  final DateTime date;
  @override
  @HiveField(1)
  final String type;
  @override
  @HiveField(2)
  final String url;
  @override
  @HiveField(3)
  final String? hdImageUrl;
  @override
  @HiveField(4)
  final String description;
  @override
  @HiveField(5)
  final String title;
  @override
  @HiveField(6)
  final String? credits;

  @override
  String toString() {
    return 'SpaceMedia(date: $date, type: $type, url: $url, hdImageUrl: $hdImageUrl, description: $description, title: $title, credits: $credits)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SpaceMedia &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.hdImageUrl, hdImageUrl) ||
                other.hdImageUrl == hdImageUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.credits, credits) || other.credits == credits));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, type, url, hdImageUrl, description, title, credits);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SpaceMediaCopyWith<_$_SpaceMedia> get copyWith =>
      __$$_SpaceMediaCopyWithImpl<_$_SpaceMedia>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SpaceMediaToJson(
      this,
    );
  }
}

abstract class _SpaceMedia implements SpaceMedia {
  factory _SpaceMedia(
      {@HiveField(0) required final DateTime date,
      @HiveField(1) required final String type,
      @HiveField(2) required final String url,
      @HiveField(3) final String? hdImageUrl,
      @HiveField(4) required final String description,
      @HiveField(5) required final String title,
      @HiveField(6) final String? credits}) = _$_SpaceMedia;

  factory _SpaceMedia.fromJson(Map<String, dynamic> json) =
      _$_SpaceMedia.fromJson;

  @override
  @HiveField(0)
  DateTime get date;
  @override
  @HiveField(1)
  String get type;
  @override
  @HiveField(2)
  String get url;
  @override
  @HiveField(3)
  String? get hdImageUrl;
  @override
  @HiveField(4)
  String get description;
  @override
  @HiveField(5)
  String get title;
  @override
  @HiveField(6)
  String? get credits;
  @override
  @JsonKey(ignore: true)
  _$$_SpaceMediaCopyWith<_$_SpaceMedia> get copyWith =>
      throw _privateConstructorUsedError;
}
