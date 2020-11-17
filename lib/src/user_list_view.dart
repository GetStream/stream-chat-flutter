import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/users_bloc.dart';

import 'stream_chat.dart';

typedef UserTapCallback = void Function(User, Widget);

///
/// It shows the list of current users.
///
/// ```dart
/// class UsersListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: UsersListView(
///         filter: {
///           'members': {
///             '\$in': [StreamChat.of(context).user.id],
///           }
///         },
///         sort: [SortOption('last_message_at')],
///         pagination: PaginationParams(
///           limit: 20,
///         ),
///         channelWidget: ChannelPage(),
///       ),
///     );
///   }
/// }
/// ```
///
///
/// Make sure to have a [StreamChat] ancestor in order to provide the information about the channels.
/// The widget uses a [ListView.custom] to render the list of channels.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class UserListView extends StatefulWidget {
  /// Instantiate a new UserListView
  const UserListView({
    Key key,
    this.errorBuilder,
    this.emptyBuilder,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
    this.onUserTap,
    this.onUserLongPress,
    this.userWidget,
    this.separatorBuilder,
    this.onImageTap,
    this.swipeToAction = false,
    this.pullToRefresh = true,
  }) : super(key: key);

  /// The builder that will be used in case of error
  final Widget Function(Error error) errorBuilder;

  /// If true a default swipe to action behaviour will be added to this widget
  final bool swipeToAction;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic> filter;

  /// Query channels options.
  ///
  /// state: if true returns the Channel state
  /// watch: if true listen to changes to this Channel in real time.
  final Map<String, dynamic> options;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created_at or member_count.
  /// Direction can be ascending or descending.
  final List<SortOption> sort;

  /// Pagination parameters
  /// limit: the number of users to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams pagination;

  /// Function called when tapping on a channel
  /// By default it calls [Navigator.push] building a [MaterialPageRoute]
  /// with the widget [userWidget] as child.
  final UserTapCallback onUserTap;

  /// Function called when long pressing on a channel
  final Function(User) onUserLongPress;

  /// Widget used when opening a channel
  final Widget userWidget;

  // /// Builder used to create a custom channel preview
  // final ChannelPreviewBuilder channelPreviewBuilder;

  /// Builder used to create a custom item separator
  final Function(BuildContext, int) separatorBuilder;

  /// The function called when the image is tapped
  final Function(User) onImageTap;

  /// Set it to false to disable the pull-to-refresh widget
  final bool pullToRefresh;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usersBloc = UsersBloc.of(context);

    if (!widget.pullToRefresh) {
      return _buildListView(usersBloc);
    }

    return RefreshIndicator(
      onRefresh: () async {
        return usersBloc.queryUsers(
          filter: widget.filter,
          sort: widget.sort,
          options: widget.options,
          pagination: widget.pagination,
        );
      },
      child: _buildListView(usersBloc),
    );
  }

  StreamBuilder<List<User>> _buildListView(
    UsersBlocState usersBlocState,
  ) {
    return StreamBuilder(
      stream: usersBlocState.usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is Error) {
            print((snapshot.error as Error).stackTrace);
          }

          if (widget.errorBuilder != null) {
            return widget.errorBuilder(snapshot.error);
          }

          var message = snapshot.error.toString();
          if (snapshot.error is DioError) {
            final dioError = snapshot.error as DioError;
            if (dioError.type == DioErrorType.RESPONSE) {
              message = dioError.message;
            } else {
              message = 'Check your connection and retry';
            }
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 2.0,
                          ),
                          child: Icon(Icons.error_outline),
                        ),
                      ),
                      TextSpan(text: 'Error loading channels'),
                    ],
                  ),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Text(message),
                ),
                FlatButton(
                  onPressed: () {
                    usersBlocState.queryUsers(
                      filter: widget.filter,
                      sort: widget.sort,
                      pagination: widget.pagination,
                      options: widget.options,
                    );
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        }

        final users = snapshot.data;

        if (users.isEmpty && widget.emptyBuilder != null) {
          return widget.emptyBuilder(context);
        }

        if (users.isEmpty && widget.emptyBuilder == null) {
          return LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Center(
                    child: Text('There are no users currently'),
                  ),
                ),
              );
            },
          );
        }

        return ListView.custom(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          childrenDelegate: SliverChildBuilderDelegate(
            (context, i) {
              return _itemBuilder(context, i, users);
            },
            childCount: (users.length * 2) + 1,
            findChildIndexCallback: (key) {
              final ValueKey<String> valueKey = key;
              final index = users.indexWhere(
                  (channel) => 'CHANNEL-${channel.id}' == valueKey.value);
              return index != -1 ? (index * 2) : null;
            },
          ),
        );
      },
    );
  }

  Widget _itemBuilder(context, int i, List<User> users) {
    if (i % 2 != 0) {
      if (widget.separatorBuilder != null) {
        return widget.separatorBuilder(context, i);
      }
      return _separatorBuilder(context, i);
    }

    i = i ~/ 2;

    final usersProvider = UsersBloc.of(context);
    if (i < users.length) {
      final user = users[i];

      UserTapCallback onTap;
      if (widget.onUserTap != null) {
        onTap = widget.onUserTap;
      } else {
        onTap = (client, _) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return StreamChannel(
          //         child: widget.userWidget,
          //         channel: client,
          //       );
          //     },
          //   ),
          // );
        };
      }

      return Container(
        key: ValueKey<String>('USER-${user.id}'),
        child: Builder(
          builder: (context) {
            Widget child;
            child = ListTile(
              title: Text(user.name),
            );
            // if (widget.channelPreviewBuilder != null) {
            //   child = Stack(
            //     children: [
            //       widget.channelPreviewBuilder(
            //         context,
            //         channel,
            //       ),
            //       Positioned.fill(
            //         child: Material(
            //           color: Colors.transparent,
            //           child: InkWell(
            //             onTap: () {
            //               onTap(channel, widget.channelWidget);
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   );
            // } else {
            //   final backgroundColor =
            //       Theme.of(context).brightness == Brightness.light
            //           ? Color(0xffEBEBEB)
            //           : Color(0xff141414);
            //   child = Slidable(
            //     enabled: widget.swipeToAction,
            //     actionPane: SlidableBehindActionPane(),
            //     actionExtentRatio: 0.12,
            //     closeOnScroll: true,
            //     secondaryActions: <Widget>[
            //       IconSlideAction(
            //         color: backgroundColor,
            //         icon: Icons.more_horiz,
            //         onTap: () {
            //           showModalBottomSheet(
            //             clipBehavior: Clip.hardEdge,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(32),
            //                 topRight: Radius.circular(32),
            //               ),
            //             ),
            //             context: context,
            //             builder: (context) {
            //               return ChannelBottomSheet(channel: channel);
            //             },
            //           );
            //         },
            //       ),
            //       IconSlideAction(
            //         color: backgroundColor,
            //         icon: StreamIcons.mute,
            //         onTap: () async {
            //           if (!channel.isMuted) {
            //             await channel.mute();
            //           } else {
            //             await channel.unmute();
            //           }
            //         },
            //       ),
            //       if (channel.isGroup && !channel.isDistinct)
            //         IconSlideAction(
            //           color: backgroundColor,
            //           icon: StreamIcons.user_minus,
            //           onTap: () async {
            //             final confirm = await showConfirmationDialog(
            //               context,
            //               'Do you want to leave the group?',
            //             );
            //             if (confirm == true) {
            //               await channel
            //                   .removeMembers([StreamChat.of(context).user.id]);
            //             }
            //           },
            //         ),
            //       if (!channel.isGroup && !channel.isDistinct)
            //         IconSlideAction(
            //           color: backgroundColor,
            //           icon: Icons.delete_outline,
            //           onTap: () async {
            //             final confirm = await showConfirmationDialog(
            //               context,
            //               'Do you want to delete the chat?',
            //             );
            //             if (confirm == true) {
            //               await channel
            //                   .removeMembers([StreamChat.of(context).user.id]);
            //             }
            //           },
            //         ),
            //     ],
            //     child: Container(
            //       color: StreamChatTheme.of(context).backgroundColor,
            //       child: ChannelPreview(
            //         onLongPress: widget.onChannelLongPress,
            //         channel: channel,
            //         onImageTap: widget.onImageTap != null
            //             ? () {
            //                 widget.onImageTap(channel);
            //               }
            //             : null,
            //         onTap: (channel) {
            //           onTap(channel, widget.userWidget);
            //         },
            //       ),
            //     ),
            //   );
            // }
            return child;
          },
        ),
      );
    } else {
      return _buildQueryProgressIndicator(context, usersProvider);
    }
  }

  Widget _buildQueryProgressIndicator(context, UsersBlocState usersProvider) {
    return StreamBuilder<bool>(
        stream: usersProvider.queryUsersLoading,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Color(0xffd0021B).withAlpha(26),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text('Error loading users'),
                ),
              ),
            );
          }
          return Container(
            height: 100,
            padding: EdgeInsets.all(32),
            child: Center(
              child: snapshot.data ? CircularProgressIndicator() : Container(),
            ),
          );
        });
  }

  Widget _separatorBuilder(context, i) {
    return Container(
      height: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.1),
    );
  }
}
