import 'package:assertable_json/src/extensions/numeric_assertions.dart';
import 'package:test/test.dart';
import 'assertable_json_base.dart';
import 'assertable_json.dart';

/// A mixin that provides numeric comparison and validation methods for JSON properties.
///
/// This mixin extends [AssertableJsonBase] to add methods for asserting numeric
/// conditions on JSON values. It supports various numeric comparisons and validations
/// including:
/// * Greater/less than comparisons
/// * Equality checks
/// * Divisibility tests
/// * Range validation
/// * Sign checking
///
/// Example usage:
///
/// ```dart
/// final json = AssertableJson({
///   'value': 42,
///   'user': {
///     'age': 30,
///     'score': 95.5
///   }
/// });
///
/// // Basic usage
/// json.isGreaterThan('value', 40);
///
/// // With dot notation for nested properties
/// json.isGreaterThan('user.age', 18);
///
/// // Chained assertions
/// json
///   .isGreaterThan('value', 40)
///   .isLessThan('value', 50)
///   .isPositive('value');
///
/// // Using with array elements
/// json.isGreaterThan('scores.0', 80);
/// ```
///
mixin ConditionMixin on AssertableJsonBase {
  /// Asserts that the numeric value at [key] is greater than [value].
  ///
  /// ```dart
  /// json.isGreaterThan('age', 18);
  /// json.isGreaterThan('user.stats.score', 80);
  /// ```
  AssertableJson isGreaterThan(String key, num value) {
    final actual = getRequired<num>(key);
    actual.assertGreaterThan(value);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is less than [value].
  ///
  /// ```dart
  /// json.isLessThan('price', 100);
  /// json.isLessThan('user.order.total', 50.99);
  /// ```
  AssertableJson isLessThan(String key, num value) {
    final actual = getRequired<num>(key);
    actual.assertLessThan(value);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is greater than or equal to [value].
  ///
  /// ```dart
  /// json.isGreaterOrEqual('quantity', 1);
  /// json.isGreaterOrEqual('user.cart.items', 0);
  /// ```
  AssertableJson isGreaterOrEqual(String key, num value) {
    final actual = getRequired<num>(key);
    actual.assertGreaterOrEqual(value);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is less than or equal to [value].
  ///
  /// ```dart
  /// json.isLessOrEqual('rating', 5);
  /// json.isLessOrEqual('product.stock.count', 100);
  /// ```
  AssertableJson isLessOrEqual(String key, num value) {
    final actual = getRequired<num>(key);
    actual.assertLessOrEqual(value);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] equals [value].
  ///
  /// ```dart
  /// json.equals('status', 200);
  /// json.equals('response.meta.code', 404);
  /// ```
  AssertableJson equals(String key, num value) {
    final actual = getRequired<num>(key);
    expect(actual == value, isTrue,
        reason: 'Property [$key] is not equal to $value');
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] does not equal [value].
  ///
  /// ```dart
  /// json.notEquals('status', 404);
  /// json.notEquals('response.meta.code', 500);
  /// ```
  AssertableJson notEquals(String key, num value) {
    final actual = getRequired<num>(key);
    expect(actual != value, isTrue,
        reason: 'Property [$key] should not equal $value');
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is divisible by [divisor].
  ///
  /// ```dart
  /// json.isDivisibleBy('count', 5);
  /// json.isDivisibleBy('products.0.quantity', 2);
  /// ```
  AssertableJson isDivisibleBy(String key, num divisor) {
    final actual = getRequired<num>(key);
    actual.assertDivisibleBy(divisor);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is a multiple of [factor].
  ///
  /// ```dart
  /// json.isMultipleOf('price', 0.25);
  /// json.isMultipleOf('order.items.0.cost', 5);
  /// ```
  AssertableJson isMultipleOf(String key, num factor) {
    final actual = getRequired<num>(key);
    actual.assertMultipleOf(factor);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is between [min] and [max] inclusive.
  ///
  /// ```dart
  /// json.isBetween('age', 18, 65);
  /// json.isBetween('product.rating', 1, 5);
  /// ```
  AssertableJson isBetween(String key, num min, num max) {
    final actual = getRequired<num>(key);
    actual.assertBetween(min, max);
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is positive (greater than zero).
  ///
  /// ```dart
  /// json.isPositive('price');
  /// json.isPositive('order.total');
  /// ```
  AssertableJson isPositive(String key) {
    final actual = getRequired<num>(key);
    actual.assertPositive();
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that the numeric value at [key] is negative (less than zero).
  ///
  /// ```dart
  /// json.isNegative('temperature');
  /// json.isNegative('account.balance');
  /// ```
  AssertableJson isNegative(String key) {
    final actual = getRequired<num>(key);
    actual.assertNegative();
    interactsWith(key);
    return this as AssertableJson;
  }
}
