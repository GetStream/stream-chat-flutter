import 'package:dio/dio.dart' show MultipartFile;
import 'package:test/test.dart';

Matcher isSameMultipartFileAs(MultipartFile targetFile) =>
    _IsSameMultipartFileAs(targetFile: targetFile);

class _IsSameMultipartFileAs extends Matcher {
  const _IsSameMultipartFileAs({required this.targetFile});

  final MultipartFile targetFile;

  @override
  Description describe(Description description) =>
      description.add('is same multipartFile as $targetFile');

  @override
  bool matches(covariant MultipartFile file, Map matchState) =>
      file.length == targetFile.length;
}
