import 'dart:math' as math;

/// Resamples the waveformData to the target size.
List<double> resampleWaveformData(
  List<double> waveformData,
  int amplitudesCount,
) {
  if (waveformData.length > amplitudesCount) {
    return downSample(waveformData, amplitudesCount);
  }

  if (waveformData.length < amplitudesCount) {
    return upSample(waveformData, amplitudesCount);
  }

  return waveformData;
}

/// Downsamples the [data] to the target output size.
///
/// The downSample function uses the Largest-Triangle-Three-Buckets (LTTB)
/// algorithm. See the thesis Downsampling Time Series for Visual Representation
/// by Sveinn Steinarsson for more (https://skemman.is/bitstream/1946/15343/3/SS_MSthesis.pdf)
List<double> downSample(List<double> data, int targetOutputSize) {
  if (data.length <= targetOutputSize || targetOutputSize == 0) return data;
  if (targetOutputSize == 1) return [_mean(data)];

  final result = <double>[];
  // bucket size adjusted due to the fact that the first and the last item in
  // the original data array is kept in target output
  final bucketSize = (data.length - 2) / (targetOutputSize - 2);
  var lastSelectedPointIndex = 0;
  result.add(data[lastSelectedPointIndex]); // Always add the first point

  for (var bucketIndex = 1; bucketIndex < targetOutputSize - 1; bucketIndex++) {
    final previousBucketRefPoint = data[lastSelectedPointIndex];
    final nextBucketMean = _getNextBucketMean(data, bucketIndex, bucketSize);

    final currentBucketStartIndex = ((bucketIndex - 1) * bucketSize).floor() + 1;
    final nextBucketStartIndex = (bucketIndex * bucketSize).floor() + 1;
    final countUnitsBetweenAtoC = 1 + nextBucketStartIndex - currentBucketStartIndex;

    var maxArea = -1.0;
    var triangleArea = -1.0;
    double? maxAreaPoint;

    for (
      var currentPointIndex = currentBucketStartIndex;
      currentPointIndex < nextBucketStartIndex;
      currentPointIndex++
    ) {
      final countUnitsBetweenAtoB = (currentPointIndex - currentBucketStartIndex).abs() + 1;
      final countUnitsBetweenBtoC = countUnitsBetweenAtoC - countUnitsBetweenAtoB;
      final currentPointValue = data[currentPointIndex];

      triangleArea = _triangleAreaHeron(
        _triangleBase(
          (previousBucketRefPoint - currentPointValue).abs(),
          countUnitsBetweenAtoB.toDouble(),
        ),
        _triangleBase(
          (currentPointValue - nextBucketMean).abs(),
          countUnitsBetweenBtoC.toDouble(),
        ),
        _triangleBase(
          (previousBucketRefPoint - nextBucketMean).abs(),
          countUnitsBetweenAtoC.toDouble(),
        ),
      );

      if (triangleArea > maxArea) {
        maxArea = triangleArea;
        maxAreaPoint = data[currentPointIndex];
        lastSelectedPointIndex = currentPointIndex;
      }
    }

    if (maxAreaPoint != null) {
      result.add(maxAreaPoint);
    }
  }

  result.add(data[data.length - 1]); // Always add the last point
  return result;
}

double _triangleAreaHeron(double a, double b, double c) {
  final s = (a + b + c) / 2;
  return math.sqrt(s * (s - a) * (s - b) * (s - c));
}

double _triangleBase(double a, double b) {
  return math.sqrt(math.pow(a, 2) + math.pow(b, 2));
}

double _mean(List<double> values) {
  return values.reduce((acc, value) => acc + value) / values.length;
}

List<int> _divMod(int num, int divisor) => [num ~/ divisor, num % divisor];

double _getNextBucketMean(
  List<double> data,
  int currentBucketIndex,
  double bucketSize,
) {
  final nextBucketStartIndex = (currentBucketIndex * bucketSize).floor() + 1;
  var nextNextBucketStartIndex = ((currentBucketIndex + 1) * bucketSize).floor() + 1;
  nextNextBucketStartIndex = nextNextBucketStartIndex < data.length ? nextNextBucketStartIndex : data.length;

  return _mean(data.sublist(nextBucketStartIndex, nextNextBucketStartIndex));
}

/// Upsamples the [data] to the target output size.
///
/// The upSample function extends the array of amplitudes by repeating the
/// values in the array.
///
/// If the target size is smaller than the length of the array, the function
/// returns the original array.
List<double> upSample(List<double> data, int targetOutputSize) {
  if (data.isEmpty) return List.filled(targetOutputSize, 0);
  if (data.length >= targetOutputSize || targetOutputSize == 0) return data;

  final divModResult = _divMod(targetOutputSize, data.length);
  final bucketSize = divModResult[0];
  var remainder = divModResult[1];

  final result = <double>[];

  for (var i = 0; i < data.length; i++) {
    final extra = remainder > 0 ? 1 : 0;
    if (remainder > 0) remainder--;
    result.addAll(List.filled(bucketSize + extra, data[i]));
  }
  return result;
}
