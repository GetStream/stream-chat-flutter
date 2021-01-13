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
          brightness: Theme.of(context).brightness,
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
                      color: StreamChatTheme.of(context).colorTheme.grey,
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
                          color: StreamChatTheme.of(context).colorTheme.grey,
                        ),
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
                  color: _isGroupNameEmpty
                      ? StreamChatTheme.of(context).colorTheme.grey
                      : StreamChatTheme.of(context).colorTheme.accentBlue,
                ),
                onPressed: _isGroupNameEmpty
                    ? null
                    : () async {
                        try {
                          final groupName = _groupNameController.text;
                          final client = StreamChat.of(context).client;
                          final channel = client.channel('messaging',
                              id: Uuid().v4(),
                              extraData: {
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
                        } catch (err) {
                          _showErrorAlert();
                        }
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
                gradient: StreamChatTheme.of(context).colorTheme.bgGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Text(
                  '$_totalUsers ${_totalUsers > 1 ? 'Members' : 'Member'}',
                  style: TextStyle(
                    color: StreamChatTheme.of(context).colorTheme.grey,
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
                    color: StreamChatTheme.of(context).colorTheme.greyWhisper,
                  ),
                  itemBuilder: (_, index) {
                    if (index == _selectedUsers.length) {
                      return Container(
                        height: 1,
                        color:
                            StreamChatTheme.of(context).colorTheme.greyWhisper,
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

  void _showErrorAlert() {
    showModalBottomSheet(
      backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      )),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 26.0,
            ),
            StreamSvgIcon.error(
              color: StreamChatTheme.of(context).colorTheme.accentRed,
              size: 24.0,
            ),
            SizedBox(
              height: 26.0,
            ),
            Text(
              'Something went wrong',
              style: StreamChatTheme.of(context).textTheme.headlineBold,
            ),
            SizedBox(
              height: 7.0,
            ),
            Text('The operation couldn\'t be completed.'),
            SizedBox(
              height: 36.0,
            ),
            Container(
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(.08),
              height: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text(
                    'OK',
                    style: StreamChatTheme.of(context)
                        .textTheme
                        .bodyBold
                        .copyWith(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentBlue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
