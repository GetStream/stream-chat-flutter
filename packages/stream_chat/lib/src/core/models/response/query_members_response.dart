import 'package:freezed_annotation/freezed_annotation.dart';

import '../member.dart';

part 'query_members_response.freezed.dart';

/// One page of the members of a channel.
///
/// See also:
///
///  * [StreamChatClient.queryMembers] and [Channel.queryMembers], which return
///    it.
@freezed
class QueryMembersResponse with _$QueryMembersResponse {
  /// Creates a new [QueryMembersResponse].
  const QueryMembersResponse({
    required this.duration,
    required this.members,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The members on this page.
  @override
  final List<Member> members;
}
