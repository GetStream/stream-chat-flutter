import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// A [TypeConverter] that serializes [VotingVisibility] to a [String] column.
class VotingVisibilityConverter extends TypeConverter<VotingVisibility, String> {
  /// Constant default constructor.
  const VotingVisibilityConverter();

  @override
  VotingVisibility fromSql(String fromDb) => VotingVisibility(fromDb);

  @override
  String toSql(VotingVisibility value) => value.value;
}
