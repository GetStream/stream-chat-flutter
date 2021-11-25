import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat/stream_chat.dart' show StreamChatError;

part 'paged_value_notifier.freezed.dart';

const defaultInitialPagedLimitMultiplier = 3;

typedef PagedValueListenableBuilder<Key, Value>
    = ValueListenableBuilder<PagedValue<Key, Value>>;

/// A [PagedValueNotifier] that uses a [PagedListenable] to load data.
///
/// This class is useful when you need to load data from a server
/// using a [PagedListenable] and want to keep the UI-driven refresh
/// signals in the [PagedListenable].
///
/// [PagedValueNotifier] is a [ValueNotifier] that emits a [PagedValue]
/// whenever the data is loaded or an error occurs.
abstract class PagedValueNotifier<Key, Value>
    extends ValueNotifier<PagedValue<Key, Value>> {
  /// Creates a [PagedValueNotifier]
  PagedValueNotifier(this._initialValue) : super(_initialValue);

  /// Stores initialValue in case we need to call [refresh].
  final PagedValue<Key, Value> _initialValue;

  /// Returns the currently loaded items
  List<Value> get currentItems => value.asSuccess.items;

  /// Appends [newItems] to the previously loaded ones and replaces
  /// the next page's key.
  void appendPage({
    required List<Value> newItems,
    required Key nextPageKey,
  }) {
    final updatedItems = currentItems + newItems;
    value = PagedValue(items: updatedItems, nextPageKey: nextPageKey);
  }

  /// Appends [newItems] to the previously loaded ones and sets the next page
  /// key to `null`.
  void appendLastPage(List<Value> newItems) {
    final updatedItems = currentItems + newItems;
    value = PagedValue(items: updatedItems);
  }

  /// Retry any failed load requests.
  ///
  /// Unlike [refresh], this does not resets the whole [value],
  /// it only retries the last failed load request.
  Future<void> retry() {
    final lastValue = value.asSuccess;
    assert(lastValue.hasError, '');

    final nextPageKey = lastValue.nextPageKey;
    // resetting the error
    value = lastValue.copyWith(error: null);
    return loadMore(nextPageKey!);
  }

  /// Refresh the data presented by this [PagedValueNotifier].
  ///
  /// Note: This API is intended for UI-driven refresh signals,
  /// such as swipe-to-refresh.
  Future<void> refresh() {
    value = _initialValue;
    return doInitialLoad();
  }

  /// Load initial data from the server.
  Future<void> doInitialLoad();

  /// Load more data from the server using [nextPageKey].
  Future<void> loadMore(Key nextPageKey);
}

@freezed
abstract class PagedValue<Key, Value> with _$PagedValue<Key, Value> {
  const PagedValue._();

  /// Represents the success state of the [PagedValue]
  // @Assert(
  //   'nextPageKey != null',
  //   'Cannot set an error if all the pages are already fetched',
  // )
  const factory PagedValue({
    /// List with all items loaded so far.
    required List<Value> items,

    /// The key for the next page to be fetched.
    Key? nextPageKey,

    /// The current error, if any.
    StreamChatError? error,
  }) = Success<Key, Value>;

  /// Represents the loading state of the [PagedValue].
  const factory PagedValue.loading() = Loading;

  /// Represents the error state of the [PagedValue].
  const factory PagedValue.error(StreamChatError error) = Error;

  /// Returns `true` if the [PagedValue] is [Success].
  bool get isSuccess => this is Success<Key, Value>;

  /// Returns the [PagedValue] as [Success].
  Success<Key, Value> get asSuccess {
    assert(
      isSuccess,
      'Cannot get asSuccess if the PagedValue is not in the Success state',
    );
    return this as Success<Key, Value>;
  }

  /// Returns `true` if the [PagedValue] is [Success]
  /// and has more items to load.
  bool get hasNextPage => asSuccess.nextPageKey != null;

  /// Returns `true` if the [PagedValue] is [Success] and has an error.
  bool get hasError => asSuccess.error != null;

  /// 
  int get itemCount {
    final count = asSuccess.items.length;
    if (hasNextPage || hasError) return count + 1;
    return count;
  }
}
