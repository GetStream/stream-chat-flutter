import 'package:stream_chat/stream_chat.dart' show PushProvider;
import 'package:test/test.dart';

void main() {
  test('PushProvider carries its wire value', () {
    expect(PushProvider.firebase, 'firebase');
    expect(PushProvider.huawei, 'huawei');
    expect(PushProvider.xiaomi, 'xiaomi');
    expect(PushProvider.apn, 'apn');
  });

  test('PushProvider interchanges with a raw string', () {
    const raw = 'firebase';

    expect(PushProvider.firebase, raw);
    expect(PushProvider.firebase.rawType, raw);
    expect(<String>[PushProvider.firebase, PushProvider.apn], ['firebase', 'apn']);
  });

  test('PushProvider accepts a value the SDK does not name', () {
    const unknown = PushProvider('onesignal');

    expect(unknown, 'onesignal');
  });
}
