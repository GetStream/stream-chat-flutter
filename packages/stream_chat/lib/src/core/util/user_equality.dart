import '../models/user.dart';

/// Whether [next] carries nothing that [current] doesn't already hold.
///
/// [User] equality leaves out [User.createdAt] and [User.updatedAt], so they
/// are compared here as well; skipping a state write on `==` alone would drop
/// an update that only changes them.
bool isSameUser(User? current, User next) =>
    current == next && current?.createdAt == next.createdAt && current?.updatedAt == next.updatedAt;
