import 'package:flutter/material.dart';

class ConnectionIndicator extends StatefulWidget {
  final IndicatorController indicatorController;

  const ConnectionIndicator({
    Key key,
    this.indicatorController,
  }) : super(key: key);

  @override
  _ConnectionIndicatorState createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  double _height = 0;
  String _text;
  Color _color;
  VoidCallback _listener;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _height,
      child: Container(
        width: double.infinity,
        child: Material(
          color: _color ?? Theme.of(context).snackBarTheme.backgroundColor,
          child: Center(
            child: Text(_text ?? ''),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _listener = () {
      final values = widget.indicatorController.indicatorValues.value;
      if (mounted) {
        setState(() {
          _height = 30;
          _text = values.text;
          _color = values.color;
        });
      }

      if (values.duration != null) {
        Future.delayed(values.duration, () {
          if (mounted) {
            setState(() {
              _height = 0;
              _text = '';
            });
          }
        });
      }
    };

    widget.indicatorController.indicatorValues.addListener(_listener);
  }

  @override
  void dispose() {
    widget.indicatorController.indicatorValues.removeListener(_listener);
    super.dispose();
  }
}

class IndicatorValues {
  final String text;
  final Color color;
  final Duration duration;

  IndicatorValues({
    this.duration,
    this.text,
    this.color,
  });
}

class IndicatorController {
  ValueNotifier<IndicatorValues> indicatorValues = ValueNotifier(null);

  void showIndicator({
    Duration duration,
    Color color,
    String text,
  }) {
    indicatorValues.value = IndicatorValues(
      text: text,
      color: color,
      duration: duration,
    );
  }
}
