import 'package:flutter/material.dart';

class ChannelPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChannelPageAppBar({
    Key key,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withAlpha(5),
                borderRadius: BorderRadius.circular(32.0),
                border: Border.all(color: Colors.black.withOpacity(.2))),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                style: Theme.of(context).textTheme.body1,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixText: '   ',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
