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
    this.hint = 'Type a name',
  }) : super(key: key);

  @override
  ChipInputTextFieldState<T> createState() => ChipInputTextFieldState<T>();
}

class ChipInputTextFieldState<T> extends State<ChipsInputTextField<T>> {
  final _chips = <T>{};
  bool _pauseItemAddition = false;

  void addItem(T item) {
    setState(() => _chips.add(item));
    if (widget.onChipAdded != null) widget.onChipAdded(item);
  }

  void removeItem(T item) {
    setState(() {
      _chips.remove(item);
      if (_chips.isEmpty) resumeItemAddition();
    });
    if (widget.onChipRemoved != null) widget.onChipRemoved(item);
  }

  void pauseItemAddition() {
    if (!_pauseItemAddition) {
      setState(() => _pauseItemAddition = true);
    }
    widget.focusNode?.unfocus();
  }

  void resumeItemAddition() {
    if (_pauseItemAddition) {
      setState(() => _pauseItemAddition = false);
    }
    widget.focusNode?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pauseItemAddition ? resumeItemAddition : null,
      child: Material(
        elevation: 1,
        color: Colors.white,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'TO:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
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
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: _chips.map((item) {
                            return widget.chipBuilder(context, item);
                          }).toList(),
                        ),
                        if (!_pauseItemAddition)
                          TextField(
                            controller: widget.controller,
                            onChanged: widget.onInputChanged,
                            focusNode: widget.focusNode,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 4.0),
                              hintText: widget.hint,
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(
                        _chips.isEmpty
                            ? StreamIcons.user
                            : StreamIcons.user_add,
                        color: Colors.black.withOpacity(0.5),
                        size: 24,
                      ),
                      onPressed:
                          !_pauseItemAddition ? null : resumeItemAddition,
                      alignment: Alignment.topRight,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      splashRadius: 24,
                      constraints: BoxConstraints.tightFor(
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
