import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// A [TypeConverter] that serializes [VotingVisibility] to a [String] column.
class VotingVisibilityConverter extends TypeConverter<VotingVisibility, String> {
  /// Constant default constructor.
  const VotingVisibilityConverter();

  @override
  VotingVisibility fromSql(String fromDb) {
    for (final entry in _votingVisibilityEnumMap.entries) {
      if (entry.value == fromDb) {
        return entry.key;
      }
    }

    throw ArgumentError(
      '`$fromDb` is not one of the supported values: '
      '${_votingVisibilityEnumMap.values.join(', ')}',
    );
  }

  @override
  String toSql(VotingVisibility value) {
    return _votingVisibilityEnumMap[value]!;
  }
}

const _votingVisibilityEnumMap = {
  VotingVisibility.anonymous: 'anonymous',
  VotingVisibility.public: 'public',
};
