import 'package:diacritic/diacritic.dart';
import 'package:meta/meta.dart';
import '../../stream_chat_flutter.dart';

/// Returns the subset of [users] whose name matches [query] using a
/// word-boundary algorithm aligned with the other Stream chat SDKs.
///
/// Every word in the normalized [query] except the last must fully equal a
/// word in the normalized user name. The last query word is matched as a
/// prefix of any name word. A user without a name is matched by [User.id]
/// instead.
///
/// Normalization strips diacritics and lowercases both sides. Results are
/// sorted alphabetically by the normalized matchable string.
@internal
List<User> searchUsersForMention(Iterable<User> users, String query) {
  final queryTokens = _tokenize(_normalize(query));
  final entries =
      users
          .map((user) => (user, _normalize(user.nameOrId)))
          .where((entry) => _matchesMentionQuery(queryTokens, entry.$2))
          .toList()
        ..sort((a, b) => a.$2.compareTo(b.$2));
  return entries.map((entry) => entry.$1).toList(growable: false);
}

bool _matchesMentionQuery(List<String> queryTokens, String formattedName) {
  if (queryTokens.isEmpty) return true;
  final nameTokens = _tokenize(formattedName);
  final lastIndex = queryTokens.length - 1;
  for (var i = 0; i < queryTokens.length; i++) {
    final token = queryTokens[i];
    final matched = i == lastIndex ? nameTokens.any((t) => t.startsWith(token)) : nameTokens.contains(token);
    if (!matched) return false;
  }
  return true;
}

String _normalize(String? value) => removeDiacritics(value ?? '').toLowerCase();

List<String> _tokenize(String value) =>
    value.split(_mentionWhitespace).where((w) => w.isNotEmpty).toList(growable: false);

final _mentionWhitespace = RegExp(r'\s+');
