import 'package:stream_chat/src/core/models/converters/v1_json_converters.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/push_provider.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:test/test.dart';

void main() {
  test('DeviceV1JsonConverter.fromJson reads a v1 device, ignoring the fields a Device does not carry', () {
    const converter = DeviceV1JsonConverter();

    final device = converter.fromJson({
      'id': 'device-id',
      'push_provider': 'firebase',
      'push_provider_name': 'staging',
      'user_id': 'user-id',
      'created_at': '2020-04-23T14:36:21.838196Z',
      'disabled': false,
    });

    expect(device, const Device(id: 'device-id', pushProvider: PushProvider.firebase));
  });

  test('DeviceV1JsonConverter.toJson writes the device under its wire keys', () {
    const converter = DeviceV1JsonConverter();

    final json = converter.toJson(const Device(id: 'device-id', pushProvider: PushProvider.apn));

    expect(json, {'id': 'device-id', 'push_provider': 'apn'});
  });

  test('DeviceV1JsonConverter.fromJson reads back what toJson writes', () {
    const converter = DeviceV1JsonConverter();

    final device = converter.fromJson(
      converter.toJson(const Device(id: 'device-id', pushProvider: PushProvider.huawei)),
    );

    expect(device, const Device(id: 'device-id', pushProvider: PushProvider.huawei));
  });

  test('userGroupsFromV1Json reads a group with ISO-8601 dates', () {
    final groups = userGroupsFromV1Json([
      {
        'id': 'g1',
        'name': 'Engineering',
        'description': 'Engineering team',
        'team_id': 'team-1',
        'created_by': 'creator-id',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
    ]);

    expect(groups, [
      UserGroup(
        createdAt: DateTime.utc(2024, 1, 1),
        createdBy: 'creator-id',
        description: 'Engineering team',
        id: 'g1',
        name: 'Engineering',
        teamId: 'team-1',
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
    ]);
  });

  test('userGroupsFromV1Json reads dates sent as epoch nanoseconds', () {
    final groups = userGroupsFromV1Json([
      {'id': 'g1', 'name': 'Engineering', 'created_at': 1704067200123456000, 'updated_at': 1704153600000000000},
    ]);

    expect(groups!.single.createdAt, DateTime.utc(2024, 1, 1, 0, 0, 0, 123, 456));
    expect(groups.single.updatedAt, DateTime.utc(2024, 1, 2));
  });

  test('userGroupsFromV1Json reads members that carry no app_pk', () {
    final groups = userGroupsFromV1Json([
      {
        'id': 'g1',
        'name': 'Engineering',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'members': [
          {'group_id': 'g1', 'user_id': 'user-1', 'is_admin': true, 'created_at': '2024-01-03T00:00:00.000Z'},
        ],
      },
    ]);

    expect(groups!.single.members, [
      UserGroupMember(createdAt: DateTime.utc(2024, 1, 3), groupId: 'g1', isAdmin: true, userId: 'user-1'),
    ]);
  });

  test('userGroupsFromV1Json leaves members null when the group carries none', () {
    final groups = userGroupsFromV1Json([
      {
        'id': 'g1',
        'name': 'Engineering',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
    ]);

    expect(groups!.single.members, isNull);
  });

  test('userGroupsFromV1Json returns null when the message carries no groups', () {
    expect(userGroupsFromV1Json(null), isNull);
  });
}
