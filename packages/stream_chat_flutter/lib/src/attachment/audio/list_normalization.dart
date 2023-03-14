
import 'dart:math';

/// Docs
class ListNormalization {
  /// A LinkedList fits this problem very well. We should evaluate its
  /// performance here.
  static List<double> shrinkList(List<double> inputList, int listSize) {
    final resultList = List<double>.empty(growable: true);

    final pace = (inputList.length / listSize).round();

    for (var i = 0; i <= inputList.length - pace; i += pace) {
      final median =
          inputList.sublist(i, i + pace).reduce((a, b) => a + b) / pace;
      resultList.add(median);
    }

    final lastListSize = inputList.length % pace;

    if (lastListSize > 0) {
      final lastBar = inputList
              .sublist(inputList.length - lastListSize)
              .reduce((a, b) => a + b) /
          lastListSize;

      resultList.add(lastBar);
    }

    return resultList;
  }

  static List<double> _expandList(List<double> inputList, int listSize) {
    final differenceRatio = listSize / inputList.length;

    final resultList = List<double>.empty(growable: true);

    if (differenceRatio > 2) {
      final pace = differenceRatio.floor();

      inputList.forEach((bar) {
        resultList.addAll(List<double>.filled(pace, bar));
      });

      final remainingSize = listSize - resultList.length;

      if (remainingSize > 0) {
        return resultList + List<double>.filled(remainingSize, resultList.last);
      } else {
        return resultList;
      }
    } else {
      const pace = 2;
      final duplicateElements =
          ((differenceRatio - 1) * inputList.length).floor();

      inputList.take(duplicateElements).forEach((bar) {
        resultList.addAll(List<double>.filled(pace, bar));
      });

      final remainingSize = listSize - resultList.length;

      if (remainingSize > 0) {
        return resultList + List<double>.filled(remainingSize, resultList.last);
      } else {
        return resultList;
      }
    }
  }

  /// This methods assumes that all elements are positives numbers.
  static List<double> _normalizeBarsHeight(List<double> inputList) {
    var maxValue = 0.0;
    var minValue = 0.0;
    inputList.forEach((e) {
      maxValue = max(maxValue, e);
      minValue = min(minValue, e);
    });

    final range = maxValue - minValue;

    if (range > 0) {
      return inputList.map((e) => e / range).toList();
    } else {
      return inputList;
    }
  }

  ///Docs
  static List<double> normalizeBars(
    List<double> inputList,
    int listSize,
    double minValue,
  ) {
    print('normalizing list: $inputList');

    //First it is necessary to ensure that all element are positive.
    final positiveList = minValue < 0
        ? inputList.map((e) => e + minValue.abs()).toList()
        : inputList;

    print('positive list: $positiveList');

    //Now we take the median of the elements
    final widthNormalized = listSize > inputList.length
        ? _expandList(positiveList, listSize)
        : shrinkList(positiveList, listSize);

    print('median list: $widthNormalized');
    //At last the normalize the height of the bars. The result of this method
    //will be a list of bars a bit bigger.
    final normalized = _normalizeBarsHeight(widthNormalized);

    print('normalized: $normalized');

    return normalized;
  }
}
