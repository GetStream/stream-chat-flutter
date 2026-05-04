import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_app/widgets/search_text_field.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showAddMembersSheet}
/// Displays the Add Members bottom sheet for [channel] — Figma frame
/// `9857:114080` (and the `Selected` / `Search` / `No Result` variants).
///
/// Resolves to `true` when the user picks one or more members and confirms
/// (the [Channel.addMembers] call has settled by then), `false` if they
/// dismiss without adding anyone.
/// {@endtemplate}
Future<bool?> showAddMembersSheet(BuildContext context, Channel channel) {
  return showStreamSheet<bool>(
    context: context,
    isDismissible: true,
    builder: (_, scrollController) => StreamChannel(
      channel: channel,
      child: AddMembersSheet(scrollController: scrollController),
    ),
  );
}

/// {@template addMembersSheet}
/// A bottom sheet that lets the current user search the directory and
/// add one or more users to the enclosing channel.
///
/// Layout:
///
///  * [StreamSheetHeader] with the auto-implied close on the leading
///    side and a primary checkmark trailing button — the checkmark stays
///    disabled until at least one user is ticked.
///  * [StreamTextInput] search field. Edits are debounced before they
///    flow into the user-list controller's filter so we don't fire a
///    new query on every keystroke.
///  * Paginated [StreamUserListView] of users that aren't already
///    members of the channel. Rows are custom — avatar + name +
///    [StreamCheckbox.circular] trailing — and tapping anywhere on the
///    row toggles selection.
///  * A custom no-result empty state when the search query yields
///    nothing.
/// {@endtemplate}
class AddMembersSheet extends StatefulWidget {
  /// {@macro addMembersSheet}
  const AddMembersSheet({super.key, this.scrollController});

  /// Scroll controller forwarded by [showStreamSheet] — wired into the
  /// inner [StreamUserListView] so dragging the list past the top
  /// dismisses the sheet.
  final ScrollController? scrollController;

  @override
  State<AddMembersSheet> createState() => _AddMembersSheetState();
}

class _AddMembersSheetState extends State<AddMembersSheet> {
  late final Channel _channel = StreamChannel.of(context).channel;
  late final StreamChatClient _client = StreamChat.of(context).client;
  late final String? _currentUserId = _client.state.currentUser?.id;

  late final StreamUserListController _userListController = StreamUserListController(
    client: _client,
    limit: 25,
    filter: _filter(query: ''),
    sort: const [SortOption<User>.asc(UserSortKey.name)],
  );

  late final TextEditingController _searchController = TextEditingController()..addListener(_onSearchChanged);

  Timer? _debounce;
  String _query = '';

  // Locally tracked selections — channel.addMembers fires only when the
  // user taps the checkmark, so toggling rows in/out is purely UI state
  // until then.
  final Set<String> _selectedIds = {};
  bool _saving = false;

  bool get _canConfirm => _selectedIds.isNotEmpty && !_saving;

  Filter _filter({required String query}) {
    final excludedIds = <String>{
      if (_currentUserId case final id?) id,
      for (final member in _channel.state!.members)
        if (member.userId case final id?) id,
    };
    return Filter.and([
      if (query.isNotEmpty) Filter.autoComplete('name', query),
      Filter.notIn('id', excludedIds.toList()),
    ]);
  }

  void _onSearchChanged() {
    final next = _searchController.text;
    if (next == _query) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _query = next);
      _userListController.filter = _filter(query: next);
      _userListController.doInitialLoad();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _userListController.dispose();
    super.dispose();
  }

  void _toggle(User user) {
    setState(() {
      if (!_selectedIds.add(user.id)) _selectedIds.remove(user.id);
    });
  }

  Future<void> _confirm() async {
    if (_selectedIds.isEmpty) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      await _channel.addMembers(_selectedIds.toList());
      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to add members: $e')),
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    final spacing = context.streamSpacing;

    return Column(
      children: [
        StreamSheetHeader(
          title: const Text('Add Members'),
          trailing: StreamButton.icon(
            icon: Icon(context.streamIcons.checkmark),
            type: .solid,
            onPressed: _canConfirm ? _confirm : null,
          ),
        ),
        SearchTextField(controller: _searchController),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: StreamUserListView(
              controller: _userListController,
              scrollController: widget.scrollController,
              separatorBuilder: (_, _, _) => SizedBox(height: spacing.xxs),
              itemBuilder: (context, users, index, _) {
                final user = users[index];
                return _UserRow(
                  user: user,
                  selected: _selectedIds.contains(user.id),
                  onTap: _saving ? null : () => _toggle(user),
                );
              },
              emptyBuilder: (context) => Center(
                child: StreamScrollViewEmptyWidget(
                  emptyIcon: Icon(context.streamIcons.search),
                  emptyTitle: const Text('No user found'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Single user row — leading [StreamUserAvatar], name, trailing circular
/// checkbox. Tapping anywhere on the row toggles selection.
class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.selected,
    required this.onTap,
  });

  final User user;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: .symmetric(horizontal: spacing.xxs),
      child: StreamListTileTheme(
        data: StreamListTileThemeData(
          minTileHeight: 48, // Matches the design's tap target size for action rows
          contentPadding: .symmetric(horizontal: spacing.sm),
        ),
        child: StreamListTile(
          leading: StreamUserAvatar(user: user, size: .md),
          title: Text(user.name),
          trailing: StreamCheckbox.circular(
            value: selected,
            onChanged: onTap == null ? null : (_) => onTap!(),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
