import 'package:json_annotation/json_annotation.dart';

/// Marks a model as serializable for the offline database, not for API payloads.
///
/// The annotated class exposes the generated code as `fromData` and `toData`.
// TODO(openapi-migration): remove in group 10
typedef DataSerializable = JsonSerializable;
