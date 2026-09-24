import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/repository/mapper/duration_response_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('DurationResponse.toModel carries the duration into an EmptyResponse', () {
    const response = api.DurationResponse(duration: '0.02ms');

    expect(response.toModel().duration, '0.02ms');
  });
}
