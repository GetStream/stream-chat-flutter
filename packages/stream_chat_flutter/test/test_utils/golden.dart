import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:golden_toolkit/src/testing_tools.dart';
import 'package:path/path.dart' as path;

const double _kGoldenDiffTolerance = 0.05;

/// Wrapper function for golden tests.
Future<void> customExpectGoldenMatches(
  WidgetTester tester,
  String name, {
  bool? autoHeight,
  Finder? finder,
  CustomPump? customPump,
  bool? skip,
}) {
  final goldenPath = path.join('test/src/goldens');
  print('goldenPath: $goldenPath');
  goldenFileComparator = CustomGoldenFileComparator(Uri.parse(goldenPath));

  return compareWithGolden(
    tester,
    name,
    autoHeight: autoHeight,
    finder: finder,
    customPump: customPump,
    skip: skip,
    // This value is actually ignored. We are forced to pass it because the
    // downstream API is structured poorly. This should be refactored.
    device: Device.phone,
    fileNameFactory: (String name, Device device) =>
        GoldenToolkit.configuration.fileNameFactory(name),
  );
}

class CustomGoldenFileComparator extends LocalFileComparator {
  CustomGoldenFileComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    print('golden.toString(): ${golden.toString()}');
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent > _kGoldenDiffTolerance) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }
}
