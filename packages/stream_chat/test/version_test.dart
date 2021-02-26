import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:stream_chat/version.dart';

void prepareTest() {
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
}

// void main() {
//   prepareTest();
//   test('stream chat version matches pubspec', () {
//     final String pubspecPath = '${Directory.current.path}/pubspec.yaml';
//     final String pubspec = File(pubspecPath).readAsStringSync();
//     final RegExp regex = RegExp('version:\s*(.*)');
//     final RegExpMatch match = regex.firstMatch(pubspec);
//     expect(match, isNotNull);
//     expect(PACKAGE_VERSION, match.group(1).trim());
//   });
// }

void main() async {
  var items = [
    ABC('Sahil', 22, 62.0),
    ABC('Devraj', 23, 76.0),
    ABC('Harsh', 18, 48.0),
    ABC('Harsh', 17, 88.0),
    ABC('Harsh', 17, 48.0),
    ABC('Devraj', 23, 74.0, {
      'Test': 'Sahil',
    }),
    ABC('Devraj', 12, 76.0, {
      'Test': 'Avni',
    }),
  ];

  var comparators = [
    (ABC a, ABC b) {
      // if (a.extraData == null) return -1;
      // if (b.extraData == null) return 1;
      // if (a.extraData == null && b.extraData == null) return 0;
      var aa = (a.extraData ?? {})['Test'] as String;
      var bb = (b.extraData ?? {})['Test'] as String;
      return aa.compareTo(bb);
    },
    // (ABC a, ABC b) => a.name.compareTo(b.name),
    // (ABC a, ABC b) => a.age.compareTo(b.age),
    // (ABC a, ABC b) => a.weight.compareTo(b.weight),
  ];

  // for (var comp in comparators.reversed) {
  //   items.sort(comp);
  // }

  // items.sort(comparators[last])

  Stream<String> getLaugh2() {
    if (true) {
      return Stream.value('HEHO');
    } else {
      return getLaugh2();
    }
  }

  Stream<String> getLaugh() async* {
    yield 'HAHA';
    await Future.delayed(const Duration(seconds: 3));
    yield 'HOHO';
    await Future.delayed(const Duration(seconds: 3));
    yield 'HEHE';
  }

  // final stream = BehaviorSubject.seeded('HAHA');
  //
  // stream.('HOHO');

  await for (var value in getLaugh2()) {
    print(value);
  }

  // stream.add('HEHE');

  // compare(ABC a, ABC b) {
  //   int result;
  //   for (final comparator in comparators) {
  //     try {
  //       result = comparator(a, b);
  //     } catch (e) {
  //       result = 0;
  //     }
  //     if (result != 0) return result;
  //   }
  //   return 0;
  // }
  //
  // items.sort(compare);
  //
  // print(items);
}

class ABC {
  final String name;
  final int age;
  final double weight;
  final Map<String, Object> extraData;

  const ABC(this.name, this.age, this.weight, [this.extraData]);

  @override
  String toString() {
    return '''
    \n
    Name : $name,
    Age : $age,
    Weight : $weight,
    ExtraData : $extraData,
    ''';
  }
}
