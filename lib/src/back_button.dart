import 'package:flutter/material.dart';

class StreamBackButton extends StatelessWidget {
  const StreamBackButton({
    Key key,
    this.onPressed,
    this.icon = Icons.arrow_back_ios_outlined,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          } else {
            Navigator.of(context).pop();
          }
        },
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(.1)
            : Colors.black.withOpacity(.1),
        child: Icon(
          icon ?? Icons.arrow_back_ios_outlined,
          size: 15,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
