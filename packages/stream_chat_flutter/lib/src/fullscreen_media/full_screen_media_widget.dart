import 'package:flutter/material.dart';

/// {@template fsmWidget}
/// An ultra-simple abstract class that allows [FullScreenMediaBuilder]
/// to call `getFsm()` and build the correct version of FullScreenMedia.
/// {@endtemplate}
abstract class FullScreenMediaWidget extends StatefulWidget {
  /// {@macro fsmWidget}
  const FullScreenMediaWidget({super.key});
}
