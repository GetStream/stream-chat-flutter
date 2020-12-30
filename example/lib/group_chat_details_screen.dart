import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:uuid/uuid.dart';

import 'main.dart';
import 'routes/routes.dart';

class GroupChatDetailsScreen extends StatefulWidget {
  final List<User> selectedUsers;

  const GroupChatDetailsScreen({
    Key key,
    @required this.selectedUsers,
  }) : super(key: key);

  @override
  _GroupChatDetailsScreenState createState() => _GroupChatDetailsScreenState();
}

class _GroupChatDetailsScreenState extends State<GroupChatDetailsScreen> {
  final _selectedUsers = <User>[];

  TextEditingController _groupNameController;

  bool _isGroupNameEmpty = true;

  int get _totalUsers => _selectedUsers.length;

  void _groupNameListener() {
    final name = _groupNameController.text;
    if (mounted) {
      setState(() {
        _isGroupNameEmpty = name.isEmpty;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedUsers.addAll(widget.selectedUsers);
    _groupNameController = TextEditingController()
      ..addListener(_groupNameListener);
  }

  @override
  void dispose() {
    _groupNameController?.removeListener(_groupNameListener);
    _groupNameController?.clear();
    _groupNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _selectedUsers);
        return false;
      },
      child: Scaffold(
        backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: StreamChatTheme.of(context).colorTheme.white,
          leading: const StreamBackButton(),
          title: Text(
            'Name of Group Chat',
            style: TextStyle(
              color: StreamChatTheme.of(context).colorTheme.black,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'NAME',
                    style: TextStyle(
                      fontSize: 12,
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .black
                          .withOpacity(0.5),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                        hintText: 'Choose a group chat name',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .black
                                .withOpacity(.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            StreamNeumorphicButton(
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: StreamSvgIcon.check(
                  size: 24,
                  color: _isGroupNameEmpty ? Colors.grey : Color(0xFF006CFF),
                ),
                onPressed: _isGroupNameEmpty
                    ? null
                    : () async {
                        final groupName = _groupNameController.text;
                        final client = StreamChat.of(context).client;
                        final channel = client
                            .channel('messaging', id: Uuid().v4(), extraData: {
                          'members': [
                            client.state.user.id,
                            ..._selectedUsers.map((e) => e.id),
                          ],
                          'name': groupName,
                        });
                        await channel.watch();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.CHANNEL_PAGE,
                          ModalRoute.withName(Routes.HOME),
                          arguments: ChannelPageArgs(channel: channel),
                        );
                      },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    StreamChatTheme.of(context).colorTheme.whiteSmoke,
                    StreamChatTheme.of(context).colorTheme.whiteSnow,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Text(
                  '$_totalUsers ${_totalUsers > 1 ? 'Members' : 'Member'}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) => FocusScope.of(context).unfocus(),
                child: ListView.separated(
                  itemCount: _selectedUsers.length + 1,
                  separatorBuilder: (_, __) => Container(
                    height: 1,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? StreamChatTheme.of(context)
                            .colorTheme
                            .white
                            .withOpacity(0.1)
                        : StreamChatTheme.of(context)
                            .colorTheme
                            .black
                            .withOpacity(0.1),
                  ),
                  itemBuilder: (_, index) {
                    if (index == _selectedUsers.length) {
                      return Container(
                        height: 1,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? StreamChatTheme.of(context)
                                .colorTheme
                                .white
                                .withOpacity(0.1)
                            : StreamChatTheme.of(context)
                                .colorTheme
                                .black
                                .withOpacity(0.1),
                      );
                    }
                    final user = _selectedUsers[index];
                    return ListTile(
                      key: ObjectKey(user),
                      leading: UserAvatar(
                        user: user,
                        constraints: BoxConstraints.tightFor(
                          width: 40,
                          height: 40,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: StreamChatTheme.of(context).colorTheme.black,
                        ),
                        padding: const EdgeInsets.all(0),
                        splashRadius: 24,
                        onPressed: () {
                          setState(() {
                            _selectedUsers.remove(user);
                          });
                          if (_selectedUsers.isEmpty) {
                            Navigator.pop(context, _selectedUsers);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
