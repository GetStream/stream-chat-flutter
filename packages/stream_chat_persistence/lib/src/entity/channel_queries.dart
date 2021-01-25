import 'package:moor/moor.dart';

@DataClassName('ChannelQueryEntity')
class ChannelQueries extends Table {
  TextColumn get queryHash => text()();

  TextColumn get channelCid => text()();

  @override
  Set<Column> get primaryKey => {
        queryHash,
        channelCid,
      };
}
