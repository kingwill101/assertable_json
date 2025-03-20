import 'package:assertable_json/src/assertable_json_base.dart'
    show AssertableJsonBase, AssertableJsonCallback;
import 'package:test/test.dart';
import 'assertable_json.dart';

/// A mixin that provides assertion methods for JSON data validation.
///
/// This mixin extends [AssertableJsonBase] to provide methods for validating JSON
/// structure and content. It includes methods for checking:
/// * Presence or absence of keys
/// * Count of elements
/// * Value existence
/// * Nested property validation
/// * Callbacks for complex validation scenarios
///
/// Example usage:
///
/// ```dart
/// final json = AssertableJson({
///   'key': 'value',
///   'items': ['item1', 'item2', 'item3'],
///   'user': {
///     'name': 'John',
///     'age': 30
///   }
/// });
///
/// json.has('key')                     // Check key exists
///     .count('items', 3)              // Check count of array
///     .missing('nonexistent')         // Verify key doesn't exist
///     .has('user', (user) => user     // Navigate and validate nested objects
///         .has('name')
///         .has('age'));
/// ```
///
mixin HasMixin on AssertableJsonBase {
  /// Verifies the count of elements at a specific key or at the root level.
  ///
  /// Usage patterns:
  /// * `count(expectedCount)` - Verifies the root level JSON has the specified count
  /// * `count(key, expectedCount)` - Verifies the element at [key] has the specified count
  ///
  /// This method supports dot notation for nested property access, and can be used
  /// with both objects and arrays.
  ///
  /// ```dart
  /// // Check root JSON object has 3 properties
  /// json.count(3);
  ///
  /// // Check 'items' array has 5 elements
  /// json.count('items', 5);
  ///
  /// // Check nested array using dot notation
  /// json.count('user.permissions', 3);
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson count(dynamic key, [int? length]) {
    if (length == null) {
      expect(this.length(), equals(key),
          reason: 'Root level does not have the expected size');
      return this as AssertableJson;
    }

    expect(this.length(key), equals(length),
        reason: 'Property [$key] does not have the expected size');
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Verifies that the count of elements at [key] is between [min] and [max], inclusive.
  ///
  /// This method is useful for validating that a collection has a reasonable number
  /// of elements without needing to check for an exact count.
  ///
  /// ```dart
  /// // Check 'items' array has between 2 and 5 elements
  /// json.countBetween('items', 2, 5);
  ///
  /// // Check nested array using dot notation
  /// json.countBetween('user.posts', 1, 10);
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson countBetween(dynamic key, dynamic min, dynamic max) {
    final length = this.length(key);
    expect(length >= min && length <= max, isTrue,
        reason: 'Property [$key] size is not between $min and $max');
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Verifies the existence of a [key] and optionally its content.
  ///
  /// This method is highly versatile and can be used in several ways:
  ///
  /// ```dart
  /// // Simply check key exists
  /// json.has('user');
  ///
  /// // Check key exists and process its value with a callback
  /// json.has('user', (user) => user
  ///   .has('name')
  ///   .has('email'));
  ///
  /// // Check array exists with specific length
  /// json.has('items', 3);
  ///
  /// // Check array exists with specific length and validate each item
  /// json.has('items', 3, (items) => items
  ///   .each((item) => item
  ///     .has('id')
  ///     .has('name')));
  ///
  /// // Using dot notation for nested properties
  /// json.has('user.profile.email');
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson has(dynamic key,
      [dynamic arg1, AssertableJsonCallback? arg2]) {
    expect(exists(key), isTrue, reason: 'Property [$key] does not exist');
    interactsWith(key);

    if (arg2 != null) {
      return has(key, (json) {
        if (arg1 != null) {
          count(key, arg1 as int);
        }
        return first(arg2).etc();
      });
    }

    if (arg1 is AssertableJsonCallback) {
      return scope(key, arg1);
    }

    if (arg1 != null) {
      return count(key, arg1 as int);
    }

    return this as AssertableJson;
  }

  /// Verifies the existence of a nested property at [path].
  ///
  /// This method is particularly useful for deep property checking using
  /// dot notation. It provides a more explicit way to verify nested properties
  /// compared to [has].
  ///
  /// ```dart
  /// // Check a deeply nested property exists
  /// json.hasNested('user.profile.settings.notifications');
  ///
  /// // Check array element property exists
  /// json.hasNested('posts.0.comments.5.author');
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson hasNested(String path) {
    expect(exists(path), isTrue,
        reason: 'Expected JSON to have nested key $path');
    interactsWith(path);
    return this as AssertableJson;
  }

  /// Verifies the existence of all specified [keys].
  ///
  /// This method provides a convenient way to check multiple keys at once.
  ///
  /// ```dart
  /// // Check multiple top-level keys
  /// json.hasAll(['id', 'name', 'email']);
  ///
  /// // Using dot notation for nested properties
  /// json.hasAll([
  ///   'user.id',
  ///   'user.name',
  ///   'user.profile.avatar'
  /// ]);
  ///
  /// // Can also be used with a single string
  /// json.hasAll('username');  // Same as json.has('username')
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson hasAll(dynamic keys) {
    if (keys is String) {
      return has(keys);
    }

    if (keys is List<String>) {
      for (var key in keys) {
        has(key);
      }
    }
    return this as AssertableJson;
  }

  /// Verifies that all specified [values] exist in the JSON object.
  ///
  /// This method checks that each value in the provided list exists
  /// as a value (not a key) in the current JSON object.
  ///
  /// ```dart
  /// // Check that specific values exist in the JSON
  /// json.hasValues(['admin', 'user', 'guest']);
  ///
  /// // Can be combined with other methods
  /// json
  ///   .has('roles')
  ///   .hasValues(['admin', 'user']);
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson hasValues(List<dynamic> values) {
    final allValues = this.values();
    for (var value in values) {
      expect(allValues.contains(value), isTrue,
          reason: 'Expected JSON to have value $value');
    }
    return this as AssertableJson;
  }

  /// Verifies that at least one of the specified [keys] exists.
  ///
  /// This method is useful when you want to ensure that at least one
  /// of several possible keys is present in the JSON.
  ///
  /// ```dart
  /// // Check that at least one of these keys exists
  /// json.hasAny(['firstName', 'first_name', 'name']);
  ///
  /// // Using dot notation
  /// json.hasAny([
  ///   'user.profile.image',
  ///   'user.avatar',
  ///   'user.picture'
  /// ]);
  ///
  /// // Can also be used with a single string
  /// json.hasAny('username');  // Same as json.has('username')
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson hasAny(dynamic keys) {
    if (keys is String) {
      return has(keys);
    }

    if (keys is List<String>) {
      final hasAnyKey = keys.any((key) => exists(key));
      expect(hasAnyKey, isTrue,
          reason: 'None of properties [${keys.join(", ")}] exist');
    }
    return this as AssertableJson;
  }

  /// Verifies that all specified [keys] are missing from the JSON.
  ///
  /// This method provides a convenient way to check that multiple keys
  /// do not exist in the JSON.
  ///
  /// ```dart
  /// // Check multiple keys are missing
  /// json.missingAll(['deleted_at', 'error', 'password']);
  ///
  /// // Using dot notation
  /// json.missingAll([
  ///   'user.creditCard',
  ///   'user.password',
  ///   'internal.debug'
  /// ]);
  ///
  /// // Can also be used with a single string
  /// json.missingAll('username');  // Same as json.missing('username')
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson missingAll(dynamic keys) {
    if (keys is String) {
      return missing(keys);
    }

    if (keys is List<String>) {
      for (var key in keys) {
        missing(key);
      }
    }
    return this as AssertableJson;
  }

  /// Verifies that the specified [key] is missing from the JSON.
  ///
  /// This method asserts that a property does not exist in the JSON,
  /// which is useful for verifying that sensitive or deprecated fields
  /// are not included.
  ///
  /// ```dart
  /// // Check a key doesn't exist
  /// json.missing('password');
  ///
  /// // Using dot notation
  /// json.missing('user.creditCardNumber');
  ///
  /// // Checking array elements
  /// json.missing('items.3');  // Check fourth element doesn't exist
  /// ```
  ///
  /// Returns this instance for method chaining.
  AssertableJson missing(String key) {
    expect(exists(key), isFalse,
        reason:
            'Property [$key] was found while it was expected to be missing');
    return this as AssertableJson;
  }
}
