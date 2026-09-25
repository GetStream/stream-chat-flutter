// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'og_attachment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OGAttachmentResponse {
  String get duration;
  String? get ogScrapeUrl;
  String? get assetUrl;
  String? get authorLink;
  String? get authorName;
  String? get imageUrl;
  String? get text;
  String? get thumbUrl;
  String? get title;
  String? get titleLink;
  String? get type;

  /// Create a copy of OGAttachmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OGAttachmentResponseCopyWith<OGAttachmentResponse> get copyWith =>
      _$OGAttachmentResponseCopyWithImpl<OGAttachmentResponse>(this as OGAttachmentResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OGAttachmentResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.ogScrapeUrl, ogScrapeUrl) || other.ogScrapeUrl == ogScrapeUrl) &&
            (identical(other.assetUrl, assetUrl) || other.assetUrl == assetUrl) &&
            (identical(other.authorLink, authorLink) || other.authorLink == authorLink) &&
            (identical(other.authorName, authorName) || other.authorName == authorName) &&
            (identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.titleLink, titleLink) || other.titleLink == titleLink) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    ogScrapeUrl,
    assetUrl,
    authorLink,
    authorName,
    imageUrl,
    text,
    thumbUrl,
    title,
    titleLink,
    type,
  );

  @override
  String toString() {
    return 'OGAttachmentResponse(duration: $duration, ogScrapeUrl: $ogScrapeUrl, assetUrl: $assetUrl, authorLink: $authorLink, authorName: $authorName, imageUrl: $imageUrl, text: $text, thumbUrl: $thumbUrl, title: $title, titleLink: $titleLink, type: $type)';
  }
}

/// @nodoc
abstract mixin class $OGAttachmentResponseCopyWith<$Res> {
  factory $OGAttachmentResponseCopyWith(OGAttachmentResponse value, $Res Function(OGAttachmentResponse) _then) =
      _$OGAttachmentResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? ogScrapeUrl,
    String? assetUrl,
    String? authorLink,
    String? authorName,
    String? imageUrl,
    String? text,
    String? thumbUrl,
    String? title,
    String? titleLink,
    String? type,
  });
}

/// @nodoc
class _$OGAttachmentResponseCopyWithImpl<$Res> implements $OGAttachmentResponseCopyWith<$Res> {
  _$OGAttachmentResponseCopyWithImpl(this._self, this._then);

  final OGAttachmentResponse _self;
  final $Res Function(OGAttachmentResponse) _then;

  /// Create a copy of OGAttachmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? ogScrapeUrl = freezed,
    Object? assetUrl = freezed,
    Object? authorLink = freezed,
    Object? authorName = freezed,
    Object? imageUrl = freezed,
    Object? text = freezed,
    Object? thumbUrl = freezed,
    Object? title = freezed,
    Object? titleLink = freezed,
    Object? type = freezed,
  }) {
    return _then(
      OGAttachmentResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        ogScrapeUrl: freezed == ogScrapeUrl
            ? _self.ogScrapeUrl
            : ogScrapeUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        assetUrl: freezed == assetUrl
            ? _self.assetUrl
            : assetUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        authorLink: freezed == authorLink
            ? _self.authorLink
            : authorLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        authorName: freezed == authorName
            ? _self.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _self.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: freezed == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbUrl: freezed == thumbUrl
            ? _self.thumbUrl
            : thumbUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        titleLink: freezed == titleLink
            ? _self.titleLink
            : titleLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
