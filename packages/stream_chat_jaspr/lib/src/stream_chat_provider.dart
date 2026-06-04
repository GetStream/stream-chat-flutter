import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';

/// An [InheritedComponent] that provides a [StreamChatClient] to its
/// descendants.
///
/// Place this at the root of your component tree so that all Stream Chat
/// components can access the client via [StreamChatProvider.of].
///
/// ```dart
/// StreamChatProvider(
///   client: myClient,
///   child: StreamChannelListView(...),
/// )
/// ```
class StreamChatProvider extends InheritedComponent {
  /// Creates a [StreamChatProvider] that makes [client] available to
  /// descendants.
  const StreamChatProvider({
    required this.client,
    required super.child,
    super.key,
  });

  /// The [StreamChatClient] available to descendants.
  final StreamChatClient client;

  /// Returns the nearest [StreamChatProvider] above [context].
  ///
  /// Throws if no provider is found.
  static StreamChatProvider of(BuildContext context) {
    final result = context.dependOnInheritedComponentOfExactType<StreamChatProvider>();
    assert(result != null, 'No StreamChatProvider found in context');
    return result!;
  }

  /// Returns the [StreamChatClient] from the nearest [StreamChatProvider]
  /// above [context].
  static StreamChatClient clientOf(BuildContext context) => of(context).client;

  @override
  bool updateShouldNotify(covariant StreamChatProvider oldComponent) {
    return client != oldComponent.client;
  }
}
