import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/src/core/models/privacy_settings.dart';
import 'package:stream_chat/src/core/util/extension.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'connect_user_details.g.dart';

/// Class that defines the user details required for connecting to Stream Chat
/// via WebSocket.
///
/// This class is used when establishing a WebSocket connection to provide
/// necessary user information.
///
/// Example:
/// ```dart
/// final userDetails = ConnectUserDetails.fromOwnUser(ownUser);
/// ```
///
/// See also:
/// - [OwnUser]: The model representing the authenticated user.
@JsonSerializable(createFactory: false, includeIfNull: false)
class ConnectUserDetails {
  /// Creates a new instance of [ConnectUserDetails].
  const ConnectUserDetails({
    required this.id,
    this.name,
    this.image,
    this.language,
    this.invisible,
    this.privacySettings,
    this.extraData,
  });

  /// Create a new instance from [OwnUser] object.
  factory ConnectUserDetails.fromOwnUser(OwnUser user) {
    return ConnectUserDetails(
      id: user.id,
      // Using extraData value in order to not use id as name.
      name: user.extraData['name'].safeCast<String>(),
      image: user.image,
      language: user.language,
      invisible: user.invisible,
      privacySettings: user.privacySettings,
      extraData: user.extraData,
    );
  }

  /// The user identifier.
  final String id;

  /// The user's display name.
  final String? name;

  /// The user's profile image URL.
  final String? image;

  /// The user's preferred language (e.g., "en", "es").
  final String? language;

  /// Whether the user wants to appear offline.
  final bool? invisible;

  /// The user's privacy preferences.
  final PrivacySettings? privacySettings;

  /// Map of custom user extraData.
  final Map<String, Object?>? extraData;

  /// Serialize to json.
  Map<String, dynamic> toJson() {
    return Serializer.moveFromExtraDataToRoot(_$ConnectUserDetailsToJson(this));
  }
}
