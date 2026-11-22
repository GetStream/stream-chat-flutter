import 'package:freezed_annotation/freezed_annotation.dart';

import 'channel_model.dart';
import 'message.dart';

part 'search_message_result.freezed.dart';

/// A message matching a search, with the channel it belongs to.
@freezed
class SearchMessageResult with _$SearchMessageResult {
  /// Creates a new [SearchMessageResult].
  const SearchMessageResult({
    required this.message,
    this.channel,
  });

  /// The matching message.
  @override
  final Message message;

  /// The channel the message belongs to, or null when it is not known.
  @override
  final ChannelModel? channel;
}
