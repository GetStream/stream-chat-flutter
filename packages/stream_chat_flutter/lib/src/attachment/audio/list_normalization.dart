import 'dart:math';

/// Normalizer of wave bars. This class shrinks bars, when they List has many
/// items, by calculating the median values, or expands the list then it has
/// to little items, by repeating items.
///
/// It is important to normalize the bars to avoid audio message with too many
/// or too little bars, which would cause then to look ugly.
class ListNormalization {
  /// Shrinks the list by taking medians. The resulting list will have the
  /// listSize.
  static List<double> normalizeWidth(List<double> inputList, int listSize) {
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

    if (resultList.length < listSize) {
      return _expandList(resultList, listSize);
    }

    return resultList;
  }

  /// Expands the list by repeating the values. The resulting list will be the
  /// size of listSize.
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

  /// Normalizes the bars by expanding it or shrinking when needed. This also
  /// normalizes the height by the highest value.
  static List<double> normalizeBars(
    List<double> inputList,
    int listSize,
    double minValue,
  ) {
    //First it is necessary to ensure that all element are positive.
    final positiveList = minValue < 0
        ? inputList.map((e) => e + minValue.abs()).toList()
        : inputList;

    //Now we take the median of the elements
    final widthNormalized = listSize > inputList.length
        ? _expandList(positiveList, listSize)
        : normalizeWidth(positiveList, listSize);
    //At last the normalize the height of the bars. The result of this method
    //will be a list of bars a bit bigger in high.
    return _normalizeBarsHeight(widthNormalized);
  }
}
