import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat/stream_chat.dart' show StreamChatError;

part 'paged_value_notifier.freezed.dart';

const defaultInitialPagedLimitMultiplier = 3;

typedef PagedValueListenableBuilder<Key, Value>
    = ValueListenableBuilder<PagedValue<Key, Value>>;

abstract class PagedValueNotifier<Key, Value>
    extends ValueNotifier<PagedValue<Key, Value>> {
  /// Creates a [PagedValueNotifier]
  PagedValueNotifier(this._initialValue) : super(_initialValue);

  /// Stores initialValue in case we need to call [refresh].
  final PagedValue<Key, Value> _initialValue;

  /// Retry any failed load requests.
  ///
  /// Unlike [refresh], this does not resets the whole [value],
  /// it only retries the last failed load request.
  Future<void> retry() {
    var lastValue = value;
    assert(lastValue.hasError, '');
    lastValue = lastValue as Success<Key, Value>;

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

  /// Creates a new instance of [PagedValue] with the given [key] and [value].
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

  bool get hasNextPage {
    assert(this is Success<Key, Value>, '');
    return (this as Success<Key, Value>).nextPageKey != null;
  }

  bool get hasError {
    assert(this is Success<Key, Value>, '');
    return (this as Success<Key, Value>).error != null;
  }

  int get itemCount {
    assert(this is Success<Key, Value>, '');
    final count = (this as Success<Key, Value>).items.length;
    if (hasNextPage || hasError) return count + 1;
    return count;
  }

  const factory PagedValue.loading() = Loading;

  const factory PagedValue.error(StreamChatError error) = Error;
}
