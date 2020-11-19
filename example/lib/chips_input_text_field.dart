import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_icons.dart';

typedef ChipBuilder<T> = Widget Function(BuildContext context, T chip);
typedef OnChipAdded<T> = void Function(T chip);
typedef OnChipRemoved<T> = void Function(T chip);

class ChipsInputTextField<T> extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onInputChanged;
  final ChipBuilder<T> chipBuilder;
  final OnChipAdded<T> onChipAdded;
  final OnChipRemoved<T> onChipRemoved;
  final String hint;

  const ChipsInputTextField({
    Key key,
    @required this.chipBuilder,
    @required this.controller,
    this.onInputChanged,
    this.focusNode,
    this.onChipAdded,
    this.onChipRemoved,
    this.hint = 'Type a name or group',
  }) : super(key: key);

  @override
  ChipInputTextFieldState<T> createState() => ChipInputTextFieldState<T>();
}

class ChipInputTextFieldState<T> extends State<ChipsInputTextField<T>> {
  final _chips = <T>{};
  bool _pauseItemAddition = false;

  void addItem(T item) {
    if (!_pauseItemAddition) {
      setState(() => _chips.add(item));
      if (widget.onChipAdded != null) widget.onChipAdded(item);
    }
  }

  void removeItem(T item) {
    setState(() {
      _chips.remove(item);
      if (_chips.isEmpty) resumeItemAddition();
    });
    if (widget.focusNode != null) widget.focusNode.requestFocus();
    if (widget.onChipRemoved != null) widget.onChipRemoved(item);
  }

  void pauseItemAddition() {
    if (!_pauseItemAddition) {
      setState(() => _pauseItemAddition = true);
    }
  }

  void resumeItemAddition() {
    if (_pauseItemAddition) {
      setState(() => _pauseItemAddition = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'TO:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: _chips.map((item) {
                        return widget.chipBuilder(context, item);
                      }).toList(),
                    ),
                    if (!_pauseItemAddition) ...[
                      if (_chips.isNotEmpty) SizedBox(height: 4),
                      TextField(
                        controller: widget.controller,
                        onChanged: widget.onInputChanged,
                        focusNode: widget.focusNode,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            hintText: widget.hint,
                            hintStyle: TextStyle(fontSize: 18)),
                      ),
                    ]
                  ],
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  _chips.isEmpty ? StreamIcons.user : StreamIcons.user_add,
                ),
                onPressed: () {
                  resumeItemAddition();
                },
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
