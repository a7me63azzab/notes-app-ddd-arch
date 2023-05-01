import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  //! NOTES FAILURES
  // Exceeded Length Failure.
  const factory ValueFailure.exceedingLength({
    required T failureValue,
    required int max,
  }) = ExceedingLength<T>;
  //Empty Failure
  const factory ValueFailure.empty({
    required T failureValue,
  }) = Empty<T>;
  //Empty Failure
  const factory ValueFailure.multiline({
    required T failureValue,
  }) = Multiline<T>;
  // List Too Long.
  const factory ValueFailure.listTooLong({
    required T failureValue,
    required int max,
  }) = ListTooLong<T>;

  //! AUTH FAILURES
  // Invalid Email.
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;
  // Invalid Password.
  const factory ValueFailure.shortPassword({
    required T failedValue,
  }) = ShortPassword<T>;
}
