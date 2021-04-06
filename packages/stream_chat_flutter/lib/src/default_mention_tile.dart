import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';

class MentionTile extends StatelessWidget {
  final Member member;
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;

  MentionTile(
    this.member, {
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 16.0,
          ),
          leading ??
              UserAvatar(
                constraints: BoxConstraints.tight(
                  Size(
                    40,
                    40,
                  ),
                ),
                user: member.user,
              ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title ??
                      Text(
                        '${member.user.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StreamChatTheme.of(context).textTheme.bodyBold,
                      ),
                  SizedBox(
                    height: 2.0,
                  ),
                  subtitle ??
                      Text(
                        '@${member.userId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StreamChatTheme.of(context)
                            .textTheme
                            .footnoteBold
                            .copyWith(
                              color:
                                  StreamChatTheme.of(context).colorTheme.grey,
                            ),
                      ),
                ],
              ),
            ),
          ),
          trailing ??
              Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 8.0),
                child: StreamSvgIcon.mentions(
                  color: StreamChatTheme.of(context).colorTheme.accentBlue,
                ),
              ),
        ],
      ),
    );
  }
}
