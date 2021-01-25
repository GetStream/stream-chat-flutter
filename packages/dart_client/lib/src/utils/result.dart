import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions.dart';

part 'result.freezed.dart';

///
@freezed
abstract class Result<T> with _$Result<T> {
  ///
  const factory Result.success({@required T data}) = Success<T>;

  ///
  const factory Result.error({@required ApiError error}) = Error<T>;
}

///
extension ResultX<T> on Result<T> {
  ///
  bool get isSuccess => this is Success<T>;

  ///
  bool get isError => this is Error<T>;

  ///
  T get data {
    if (isError) {
      throw Exception(
        'Result is not successful. Check result.isSuccess before reading the data.',
      );
    }
    return (this as Success<T>).data;
  }

  ///
  ApiError get error {
    if (isSuccess) {
      throw Exception(
        'Result is successful, not an error. Check result.isError before reading the error.',
      );
    }
    return (this as Error<T>).error;
  }
}
