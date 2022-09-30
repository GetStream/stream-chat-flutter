# conditional_parent_builder

A widget that allows developers to conditionally wrap a child widget with a parent widget.
This is useful in situations where a child widget should always be built, but should be wrapped
by another widget if certain conditions are met.

In the following real-world example, we conditionally wrap the child widget
tree with a context menu if the message is not deleted:
```dart
ConditionalParentBuilder(
  builder: (context, child) {
    if (!widget.message.isDeleted) {
      return ContextMenuArea(
        builder: (context) => buildContextMenu(),
        child: child,
      );
    } else {
      return child;
    }
  },
  child: Material(...),
),
```
This example can be found in the `stream_chat_flutter` source code under
`src/message_widget/message_widget.dart`.