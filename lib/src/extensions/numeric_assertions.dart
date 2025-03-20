import 'dart:math';

import 'package:test/test.dart';

/// Extension providing assertion methods for numeric values.
///
/// This extension adds various assertion methods to [num] types to help with
/// testing numeric conditions. Each method performs a specific validation and
/// throws a test failure if the condition is not met.
///
/// Example usage:
///
/// ```dart
/// void main() {
///   test('numeric assertions', () {
///     // Basic comparison assertions
///     5.assertGreaterThan(3);
///     3.assertLessThan(5);
///     5.assertGreaterOrEqual(5);
///     5.assertLessOrEqual(5);
///
///     // Range verification
///     15.assertBetween(10, 20);
///
///     // Mathematical property assertions
///     10.assertDivisibleBy(2);
///     10.assertMultipleOf(5);
///     25.assertPerfectSquare();
///
///     // Sign testing
///     5.assertPositive();
///     (-5).assertNegative();
///     0.assertZero();
///
///     // Number property testing
///     4.assertEven();
///     3.assertOdd();
///     7.assertPrime();
///
///     // With custom messages
///     5.assertGreaterThan(3, message: 'Custom error message');
///   });
/// }
/// ```
///
extension NumericAssertions on num {
  /// Asserts that this number is greater than [value].
  ///
  /// Throws a test failure if this number is not greater than [value].
  ///
  /// Example:
  ///
  /// ```dart
  /// 5.assertGreaterThan(3); // Passes
  /// 3.assertGreaterThan(5); // Fails with "Expected 3 to be greater than 5"
  /// ```
  ///
  /// - [value]: The value to compare against.
  /// - [message]: Optional custom message for the failure reason.
  void assertGreaterThan(num value, {String? message}) {
    expect(this > value, isTrue,
        reason: message ?? 'Expected $this to be greater than $value');
  }

  /// Asserts that this number is less than [value].
  ///
  /// Throws a test failure if this number is not less than [value].
  ///
  /// Example:
  ///
  /// ```dart
  /// 3.assertLessThan(5); // Passes
  /// 5.assertLessThan(3); // Fails with "Expected 5 to be less than 3"
  /// ```
  ///
  /// - [value]: The value to compare against.
  /// - [message]: Optional custom message for the failure reason.
  void assertLessThan(num value, {String? message}) {
    expect(this < value, isTrue,
        reason: message ?? 'Expected $this to be less than $value');
  }

  /// Asserts that this number is greater than or equal to [value].
  ///
  /// Throws a test failure if this number is not greater than or equal to [value].
  ///
  /// Example:
  ///
  /// ```dart
  /// 5.assertGreaterOrEqual(5); // Passes (equal)
  /// 6.assertGreaterOrEqual(5); // Passes (greater)
  /// 4.assertGreaterOrEqual(5); // Fails
  /// ```
  ///
  /// - [value]: The value to compare against.
  /// - [message]: Optional custom message for the failure reason.
  void assertGreaterOrEqual(num value, {String? message}) {
    expect(this >= value, isTrue,
        reason:
            message ?? 'Expected $this to be greater than or equal to $value');
  }

  /// Asserts that this number is less than or equal to [value].
  ///
  /// Throws a test failure if this number is not less than or equal to [value].
  ///
  /// Example:
  ///
  /// ```dart
  /// 5.assertLessOrEqual(5); // Passes (equal)
  /// 4.assertLessOrEqual(5); // Passes (less)
  /// 6.assertLessOrEqual(5); // Fails
  /// ```
  ///
  /// - [value]: The value to compare against.
  /// - [message]: Optional custom message for the failure reason.
  void assertLessOrEqual(num value, {String? message}) {
    expect(this <= value, isTrue,
        reason: message ?? 'Expected $this to be less than or equal to $value');
  }

  /// Asserts that this number is between [min] and [max] (inclusive).
  ///
  /// Throws a test failure if this number is not between [min] and [max].
  ///
  /// Example:
  ///
  /// ```dart
  /// 15.assertBetween(10, 20); // Passes
  /// 10.assertBetween(10, 20); // Passes (boundary)
  /// 20.assertBetween(10, 20); // Passes (boundary)
  /// 5.assertBetween(10, 20);  // Fails
  /// 25.assertBetween(10, 20); // Fails
  /// ```
  ///
  /// - [min]: The minimum value of the range.
  /// - [max]: The maximum value of the range.
  /// - [message]: Optional custom message for the failure reason.
  void assertBetween(num min, num max, {String? message}) {
    expect(this >= min && this <= max, isTrue,
        reason: message ?? 'Expected $this to be between $min and $max');
  }

  /// Asserts that this number is evenly divisible by [divisor].
  ///
  /// Throws a test failure if this number is not evenly divisible by [divisor].
  ///
  /// Example:
  ///
  /// ```dart
  /// 10.assertDivisibleBy(2);  // Passes
  /// 10.assertDivisibleBy(5);  // Passes
  /// 10.assertDivisibleBy(3);  // Fails
  /// ```
  ///
  /// - [divisor]: The number to divide by.
  /// - [message]: Optional custom message for the failure reason.
  void assertDivisibleBy(num divisor, {String? message}) {
    expect(this % divisor == 0, isTrue,
        reason: message ?? 'Expected $this to be divisible by $divisor');
  }

  /// Asserts that this number is a multiple of [factor].
  ///
  /// Throws a test failure if this number is not a multiple of [factor].
  ///
  /// Example:
  ///
  /// ```dart
  /// 10.assertMultipleOf(5);  // Passes
  /// 10.assertMultipleOf(2);  // Passes
  /// 10.assertMultipleOf(3);  // Fails
  /// ```
  ///
  /// - [factor]: The factor to check against.
  /// - [message]: Optional custom message for the failure reason.
  void assertMultipleOf(num factor, {String? message}) {
    expect(this / factor % 1 == 0, isTrue,
        reason: message ?? 'Expected $this to be a multiple of $factor');
  }

  /// Asserts that this number is positive (greater than zero).
  ///
  /// Throws a test failure if this number is not positive.
  ///
  /// Example:
  ///
  /// ```dart
  /// 5.assertPositive();   // Passes
  /// 0.assertPositive();   // Fails
  /// (-5).assertPositive(); // Fails
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertPositive({String? message}) {
    expect(this > 0, isTrue,
        reason: message ?? 'Expected $this to be positive');
  }

  /// Asserts that this number is negative (less than zero).
  ///
  /// Throws a test failure if this number is not negative.
  ///
  /// Example:
  ///
  /// ```dart
  /// (-5).assertNegative(); // Passes
  /// 0.assertNegative();    // Fails
  /// 5.assertNegative();    // Fails
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertNegative({String? message}) {
    expect(this < 0, isTrue,
        reason: message ?? 'Expected $this to be negative');
  }

  /// Asserts that this number is exactly zero.
  ///
  /// Throws a test failure if this number is not zero.
  ///
  /// Example:
  ///
  /// ```dart
  /// 0.assertZero();    // Passes
  /// 5.assertZero();    // Fails
  /// (-5).assertZero(); // Fails
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertZero({String? message}) {
    expect(this == 0, isTrue, reason: message ?? 'Expected $this to be zero');
  }

  /// Asserts that this number is even.
  ///
  /// Throws a test failure if this number is not even.
  ///
  /// Example:
  ///
  /// ```dart
  /// 2.assertEven();  // Passes
  /// 4.assertEven();  // Passes
  /// 0.assertEven();  // Passes
  /// 3.assertEven();  // Fails
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertEven({String? message}) {
    expect(this % 2 == 0, isTrue,
        reason: message ?? 'Expected $this to be even');
  }

  /// Asserts that this number is odd.
  ///
  /// Throws a test failure if this number is not odd.
  ///
  /// Example:
  ///
  /// ```dart
  /// 1.assertOdd();  // Passes
  /// 3.assertOdd();  // Passes
  /// 5.assertOdd();  // Passes
  /// 2.assertOdd();  // Fails
  /// 0.assertOdd();  // Fails
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertOdd({String? message}) {
    expect(this % 2 != 0, isTrue,
        reason: message ?? 'Expected $this to be odd');
  }

  /// Asserts that this number is prime.
  ///
  /// A prime number is a natural number greater than 1 that is only divisible by 1 and itself.
  /// This method uses trial division to check primality.
  ///
  /// Throws a test failure if this number is not prime.
  ///
  /// Example:
  ///
  /// ```dart
  /// 2.assertPrime();   // Passes
  /// 3.assertPrime();   // Passes
  /// 5.assertPrime();   // Passes
  /// 7.assertPrime();   // Passes
  /// 11.assertPrime();  // Passes
  /// 4.assertPrime();   // Fails
  /// 6.assertPrime();   // Fails
  /// 1.assertPrime();   // Fails (1 is not prime by definition)
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertPrime({String? message}) {
    if (this <= 1) {
      fail(message ?? '$this is not prime');
    }
    if (this <= 3) return;
    if (this % 2 == 0 || this % 3 == 0) {
      fail(message ?? '$this is not prime');
    }

    for (var i = 5; i * i <= this; i += 6) {
      if (this % i == 0 || this % (i + 2) == 0) {
        fail(message ?? '$this is not prime');
      }
    }
  }

  /// Asserts that this number is a perfect square.
  ///
  /// A perfect square is an integer that is the square of another integer.
  ///
  /// Throws a test failure if this number is not a perfect square.
  ///
  /// Example:
  ///
  /// ```dart
  /// 1.assertPerfectSquare();   // Passes (1 = 1²)
  /// 4.assertPerfectSquare();   // Passes (4 = 2²)
  /// 9.assertPerfectSquare();   // Passes (9 = 3²)
  /// 16.assertPerfectSquare();  // Passes (16 = 4²)
  /// 25.assertPerfectSquare();  // Passes (25 = 5²)
  /// 2.assertPerfectSquare();   // Fails
  /// 3.assertPerfectSquare();   // Fails
  /// 10.assertPerfectSquare();  // Fails
  /// ```
  ///
  /// - [message]: Optional custom message for the failure reason.
  void assertPerfectSquare({String? message}) {
    expect(sqrt(this) % 1 == 0, isTrue,
        reason: message ?? 'Expected $this to be a perfect square');
  }
}
