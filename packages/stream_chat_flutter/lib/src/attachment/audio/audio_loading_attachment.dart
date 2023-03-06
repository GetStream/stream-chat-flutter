import 'package:flutter/material.dart';

///Docs
class AudioLoadingMessage extends StatelessWidget {
  ///Docs
  const AudioLoadingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.mic),
          ),
        ],
      ),
    );
  }
}
