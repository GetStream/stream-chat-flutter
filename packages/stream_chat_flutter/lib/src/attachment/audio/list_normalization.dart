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
  static List<double> shrinkWidth(List<double> inputList, int listSize) {
    final resultList = List<double>.empty(growable: true);

    final pace = inputList.length / listSize;
    var acc = 0.0;

    /// Each time the pace is summed, it round is take. It we round pace only
    /// one time, it deviates too much from the true median of all elements.
    /// The last page is calculated separately.
    while (acc <= inputList.length - pace) {
      final median = inputList
              .sublist(acc.round(), (acc + pace).round())
              .reduce((a, b) => a + b) /
          pace.round();

      resultList.add(median);

      acc += pace;
    }

    final lastListSize = (inputList.length % pace).round();

    /// The last page.
    if (lastListSize > 0) {
      final lastBar = inputList
              .sublist(inputList.length - lastListSize)
              .reduce((a, b) => a + b) /
          lastListSize;

      resultList.add(lastBar);
    }

    return resultList;
  }

  /// Expands the list by repeating the values. The resulting list will be the
  /// size of listSize.
  static List<double> _expandList(List<double> inputList, int listSize) {
    final differenceRatio = listSize / inputList.length;

    final resultList = List<double>.empty(growable: true);

    if (differenceRatio > 2) {
      final pace = differenceRatio.round();

      // Here we repeat the elements excluding the last page. It is done this
      // because the last page can be a little bigger or a little shorter.
      // Because of that, there a special logic for it.
      inputList.take(inputList.length - 1).forEach((bar) {
        resultList.addAll(List<double>.filled(pace, bar));
      });

      final remainingSize = listSize - resultList.length;

      // The last page.
      if (remainingSize > 0) {
        return resultList + List<double>.filled(remainingSize, resultList.last);
      } else {
        return resultList;
      }
    } else {
      /// In this case the resulting list must not be at least 2x the size of
      /// the input list. Then only the first percentage of the bars is
      /// duplicated. This case may produce bars that not very close of the
      /// truth.
      const pace = 2;
      final duplicateElements =
          ((differenceRatio - 1) * inputList.length).round();

      inputList
          .take(min(duplicateElements, inputList.length - 1))
          .forEach((bar) {
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

  /// This methods assumes that all elements are positives numbers .
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
        ? inputList.map((e) => e - minValue).toList()
        : inputList;

    //Now we take the median of the elements
    final widthNormalized = listSize > inputList.length
        ? _expandList(positiveList, listSize)
        : shrinkWidth(positiveList, listSize);
    
    //At last normalisation of the height of the bars. The result of this method
    //will be a list of bars a bit bigger in high.
    return _normalizeBarsHeight(widthNormalized);
  }
}
