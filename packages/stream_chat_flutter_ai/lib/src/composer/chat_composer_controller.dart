import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter_ai/src/composer/chat_option.dart';

/// Controller for [ChatComposer] that holds all mutable UI state.
///
/// Manages:
/// - The text field content (via an internal [TextEditingController]).
/// - The list of available [ChatOption] suggestion chips.
/// - The currently selected [ChatOption].
/// - Whether the AI is currently generating a response.
///
/// Example:
/// ```dart
/// final controller = ChatComposerController(
///   chatOptions: [
///     ChatOption(id: 'summarize', text: 'Summarize this', icon: Icons.summarize),
///     ChatOption(id: 'email', text: 'Write an email', icon: Icons.email),
///   ],
/// );
/// ```
class ChatComposerController extends ChangeNotifier {
  /// Creates an [ChatComposerController].
  ///
  /// [initialText] pre-fills the text field.
  /// [chatOptions] sets the initial list of suggestion chips.
  ChatComposerController({
    String initialText = '',
    List<ChatOption> chatOptions = const [],
  }) : _chatOptions = chatOptions,
       _textController = TextEditingController(text: initialText) {
    _textController.addListener(_onTextChanged);
  }

  final TextEditingController _textController;
  List<ChatOption> _chatOptions;
  ChatOption? _selectedChatOption;
  bool _isGenerating = false;
  final List<XFile> _attachments = [];

  /// The underlying [TextEditingController] — pass this to a [TextField].
  TextEditingController get textEditingController => _textController;

  /// The current text in the input field.
  String get text => _textController.text;

  /// Whether the input field contains non-whitespace text.
  bool get hasText => text.trim().isNotEmpty;

  /// Whether the input field contains text and/or pending attachments.
  ///
  /// Used to decide whether the send button is enabled — a message with only
  /// images and no text is still sendable.
  bool get hasContent => hasText || _attachments.isNotEmpty;

  /// The images the user has picked to send alongside the message.
  List<XFile> get attachments => List.unmodifiable(_attachments);

  /// Adds [files] to the pending attachments.
  void addAttachments(Iterable<XFile> files) {
    _attachments.addAll(files);
    notifyListeners();
  }

  /// Removes a single pending attachment.
  void removeAttachment(XFile file) {
    if (_attachments.remove(file)) notifyListeners();
  }

  /// Whether the AI is currently generating a response.
  ///
  /// When `true`, [ChatComposer] shows a stop button instead of a send
  /// button.
  bool get isGenerating => _isGenerating;
  set isGenerating(bool value) {
    if (_isGenerating == value) return;
    _isGenerating = value;
    notifyListeners();
  }

  /// The list of suggestion chips shown above the input field.
  List<ChatOption> get chatOptions => _chatOptions;
  set chatOptions(List<ChatOption> value) {
    _chatOptions = value;
    notifyListeners();
  }

  /// The option the user has tapped, displayed inline inside the input box.
  ///
  /// `null` when no option is selected.
  ChatOption? get selectedChatOption => _selectedChatOption;

  /// Marks [option] as selected and hides the chip row.
  void selectChatOption(ChatOption option) {
    _selectedChatOption = option;
    notifyListeners();
  }

  /// Removes the currently selected option without clearing the text field.
  void clearSelectedChatOption() {
    _selectedChatOption = null;
    notifyListeners();
  }

  /// Clears the text field, the selected option, and any pending attachments.
  ///
  /// Call this after a successful send.
  void clear() {
    _textController.clear();
    _selectedChatOption = null;
    _attachments.clear();
    notifyListeners();
  }

  void _onTextChanged() => notifyListeners();

  @override
  void dispose() {
    _textController
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }
}
