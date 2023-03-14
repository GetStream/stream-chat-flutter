import 'dart:collection';

/// Docs
class ListNormalization {
  /// A LinkedList fits this problem very well. We should evaluate its
  /// performance here.
  static List<double> normalizeList(List<double> inputList, int listSize) {
    final resultList = List<double>.empty(growable: true);

    final pace = (inputList.length / listSize).ceil();

    for (var i = 0; i <= inputList.length - pace; i += pace) {
      final median =
          inputList.sublist(i, i + pace).reduce((a, b) => a + b) / (pace - i);
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
}
