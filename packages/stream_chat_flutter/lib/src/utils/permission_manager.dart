// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';

export 'package:permission_handler/permission_handler.dart';

final _permissionRequestLock = Lock();

class _StreamPermissionManager {
  _StreamPermissionManager._();

  /// Singleton instance of [_IVideoService]
  static final _StreamPermissionManager instance = _StreamPermissionManager._();

  /// Returns true if the [_permissionRequestLock] is currently locked.
  bool get isLocked => _permissionRequestLock.locked;

  /// Executes [computation] when [_permissionRequestLock] is available.
  ///
  /// Only one asynchronous block can run while the [_permissionRequestLock]
  /// is retained.
  Future<T> runInPermissionRequestLock<T>(
    FutureOr<T> Function() computation, {
    Duration? timeout,
  }) {
    return _permissionRequestLock.synchronized(
      computation,
      timeout: timeout,
    );
  }

  /// Request the user for access to this [Permission], if access hasn't already
  /// been grant access before.
  ///
  /// Returns the new [PermissionStatus].
  Future<PermissionStatus> requestPermission(Permission permission) {
    return runInPermissionRequestLock(() => permission.request());
  }

  /// Requests the user for access to these permissions, if they haven't already
  /// been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
  Future<Map<Permission, PermissionStatus>> requestPermissions({
    required List<Permission> permissions,
  }) {
    return runInPermissionRequestLock(() => permissions.request());
  }

  /// Opens the app settings page.
  ///
  /// Returns [true] if the app settings page could be opened,
  /// otherwise [false].
  Future<bool> launchAppSettings() {
    return runInPermissionRequestLock(openAppSettings);
  }
}

/// A class to safely requesting app permissions with a lock.
_StreamPermissionManager get StreamPermissionManager =>
    _StreamPermissionManager.instance;
