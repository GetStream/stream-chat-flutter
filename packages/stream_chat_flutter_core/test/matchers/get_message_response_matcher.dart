import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Matcher isSameMessageResponseAs(GetMessageResponse targetResponse) =>
    _IsSameMessageResponseAs(targetResponse: targetResponse);

class _IsSameMessageResponseAs extends Matcher {
  const _IsSameMessageResponseAs({
    @required this.targetResponse,
  }) : assert(targetResponse != null, '');

  final GetMessageResponse targetResponse;

  @override
  bool matches(covariant GetMessageResponse response, Map matchState) =>
      response.message.id == targetResponse.message.id &&
      response.channel.cid == targetResponse.channel.cid;

  @override
  Description describe(Description description) =>
      description.add('is same message response as $targetResponse');
}

Matcher isSameMessageResponseListAs(
        List<GetMessageResponse> targetResponseList) =>
    _IsSameMessageResponseListAs(targetResponseList: targetResponseList);

class _IsSameMessageResponseListAs extends Matcher {
  const _IsSameMessageResponseListAs({
    @required this.targetResponseList,
  }) : assert(targetResponseList != null, '');

  final List<GetMessageResponse> targetResponseList;

  @override
  bool matches(
      covariant List<GetMessageResponse> responseList, Map matchState) {
    bool matches = true;
    for (var i = 0; i < responseList.length; i++) {
      final response = responseList[i];
      final targetResponse = targetResponseList[i];
      matches = isSameMessageResponseAs(targetResponse).matches(
        response,
        matchState,
      );
      if (!matches) break;
    }
    return matches;
  }

  @override
  Description describe(Description description) =>
      description.add('is same userResponseList as $targetResponseList');
}
