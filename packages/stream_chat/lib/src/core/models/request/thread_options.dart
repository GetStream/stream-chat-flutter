import 'package:freezed_annotation/freezed_annotation.dart';

part 'thread_options.freezed.dart';

/// {@template threadOptions}
/// How much of each thread a thread query or fetch returns, and whether the current user starts watching it.
/// {@endtemplate}
@freezed
class ThreadOptions with _$ThreadOptions {
  /// {@macro threadOptions}
  const ThreadOptions({
    this.watch = true,
    this.replyLimit = 2,
    this.participantLimit = 10,
    this.memberLimit = 10,
  });

  /// Whether the current user starts watching the threads returned, receiving their updates as events.
  ///
  /// Defaults to true.
  @override
  final bool watch;

  /// The number of most recent replies to return per thread.
  ///
  /// Defaults to 2.
  @override
  final int replyLimit;

  /// The number of thread participants to return per thread.
  ///
  /// Defaults to 10.
  @override
  final int participantLimit;

  /// The number of members of the thread's channel to return per thread.
  ///
  /// Defaults to 10.
  @override
  final int memberLimit;
}
