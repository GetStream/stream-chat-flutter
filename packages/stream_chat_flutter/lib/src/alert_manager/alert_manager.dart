import 'package:flutter/material.dart';

///
abstract class AlertManager {
  ///
  Future<bool?> showConfirmationAlert(
    BuildContext context, {
    required String title,
    required String okText,
    Widget? icon,
    String? question,
    String? cancelText,
  });

  ///
  Future<bool?> showInfoAlert(
    BuildContext context, {
    required String title,
    required String okText,
    Widget? icon,
    String? details,
  });
}
