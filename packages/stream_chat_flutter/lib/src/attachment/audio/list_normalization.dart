/// Docs
class ListNormalization {
  /// Docs
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

    return resultList;
  }
}
