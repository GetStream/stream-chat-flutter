import 'package:collection/collection.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

///
class StreamPhotoGalleryController
    extends PagedValueNotifier<int, AssetEntity> {
  ///
  StreamPhotoGalleryController({
    this.limit = 50,
  }) : super(const PagedValue.loading());

  /// The maximum number of items to load at once.
  final int limit;

  Future<AssetPathEntity?> _getRecentAssetPathList({
    RequestType type = RequestType.common,
    FilterOptionGroup? filterOption,
  }) {
    return PhotoManager.getAssetPathList(
      type: type,
      onlyAll: true,
      filterOption: filterOption,
    ).then((it) => it.firstOrNull);
  }

  @override
  Future<void> doInitialLoad() async {
    try {
      final assets = await _getRecentAssetPathList();

      if (assets == null) {
        value = const PagedValue(items: []);
        return;
      }

      final mediaList = await assets.getAssetListPaged(
        page: 0,
        size: limit,
      );

      final nextKey = mediaList.length < limit ? null : 1;
      value = PagedValue(
        items: mediaList,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      value = PagedValue.error(error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = PagedValue.error(chatError);
    }
  }

  @override
  Future<void> loadMore(int page) async {
    final previousValue = value.asSuccess;

    try {
      final assets = await _getRecentAssetPathList();

      if (assets == null) {
        const chatError = StreamChatError('No media found');
        value = previousValue.copyWith(error: chatError);
        return;
      }

      final mediaList = await assets.getAssetListPaged(
        page: page,
        size: limit,
      );

      final previousItems = previousValue.items;
      final newItems = previousItems + mediaList;
      final nextKey = mediaList.length < limit ? null : page + 1;
      value = PagedValue(
        items: newItems,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      value = previousValue.copyWith(error: error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = previousValue.copyWith(error: chatError);
    }
  }
}
