import 'package:assertable_json/src/assertable_json.dart' show AssertableJson;
import 'package:test/test.dart';

import 'assertable_json_base.dart';

/// A mixin that provides JSON assertion capabilities for testing.
///
/// This mixin extends [AssertableJsonBase] to provide methods for validating JSON data
/// structures. It includes functionality for:
/// * Comparing JSON property values against expected values
/// * Type checking of JSON properties
/// * Validating JSON schema structures
/// * Checking for presence/absence of values in arrays
/// * Ensuring consistent property ordering for reliable comparisons
///
/// Example usage:
///
/// ```dart
/// // Basic value matching
/// final json = AssertableJson({'name': 'John', 'age': 30, 'hobbies': ['reading', 'gaming']});
///
/// // Simple value assertion
/// json.where('name', 'John');
///
/// // Type checking
/// json.whereType`<int>`('age');
/// json.whereType`<List>`('hobbies');
/// json.whereAllType`<String>`(['name', 'title']);
///
/// // Value containment
/// json.whereContains('hobbies', 'reading');
/// json.whereContains('name', 'Jo');  // Substring matching
///
/// // Multiple value checks
/// json.whereAll({
///   'name': 'John',
///   'age': 30
/// });
///
/// // Value inclusion/exclusion
/// json.whereIn('age', [25, 30, 35]);
/// json.whereNotIn('age', [20, 40, 50]);
///
/// // Negative assertions
/// json.whereNot('name', 'Jane');
/// json.whereNot('age', (val) => val > 40);
///
/// // Schema validation
/// json.matchesSchema({
///   'name': String,     // Required field
///   'age': int,        // Required field
///   'title?': String,  // Optional field
///   'hobbies': List    // Required field
/// });
/// ```
///
mixin MatchingMixin on AssertableJsonBase {
  /// Ensures all nested maps within the given [value] have their entries sorted by key.
  ///
  /// This is used internally to provide consistent ordering when comparing maps.
  void ensureSorted(Map<String, dynamic> value) {
    value.forEach((key, val) {
      if (val is Map) {
        ensureSorted(val as Map<String, dynamic>);
      }
    });

    final sorted = Map.fromEntries(
        value.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    value.clear();
    value.addAll(sorted);
  }

  /// Asserts that a property matches an expected value or satisfies a condition.
  ///
  /// The [key] specifies the property to check, and [expected] can be either:
  /// * A direct value to compare against
  /// * A function that returns true if the value is valid
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Direct value comparison
  /// json.where('name', 'John');
  /// json.where('age', 30);
  ///
  /// // Using a function condition
  /// json.where('age', (value) => value > 18);
  /// json.where('name', (value) => value.startsWith('J'));
  ///
  /// // Nested object comparison
  /// json.where('address', {'city': 'New York', 'zip': '10001'});
  ///
  /// // Using dot notation for nested properties
  /// json.where('user.profile.name', 'John');
  /// json.where('user.settings.theme', 'dark');
  ///
  /// // With array elements
  /// json.where('posts.0.title', 'First Post');
  /// json.where('tags.1', 'important');
  ///
  /// // With closures and dot notation
  /// json.where('user.profile.age', (age) => age >= 21);
  /// ```
  ///
  AssertableJson where(String key, dynamic expected) {
    (this as AssertableJson).has(key);
    final actual = get(key);

    if (expected is Function) {
      expect(expected(actual), isTrue,
          reason: 'Property [$key] was marked as invalid using a closure');
      return (this as AssertableJson);
    }

    if (expected is Map) {
      ensureSorted(expected as Map<String, dynamic>);
    }
    if (actual is Map) {
      ensureSorted(actual as Map<String, dynamic>);
    }

    expect(actual, equals(expected),
        reason: 'Property [$key] does not match expected value');

    return (this as AssertableJson);
  }

  /// Asserts that a property does not match an unexpected value.
  ///
  /// The [key] specifies the property to check, and [unexpected] can be either:
  /// * A direct value that should not match
  /// * A function that returns false if the value is valid
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Direct value mismatch
  /// json.whereNot('name', 'Jane');
  /// json.whereNot('age', 25);
  ///
  /// // Using a function condition
  /// json.whereNot('age', (value) => value < 18);
  /// json.whereNot('status', (value) => value == 'inactive');
  ///
  /// // Using dot notation
  /// json.whereNot('user.profile.name', 'Jane');
  /// json.whereNot('user.settings.notifications', false);
  ///
  /// // With array elements
  /// json.whereNot('posts.0.status', 'draft');
  /// json.whereNot('tags.2', 'deprecated');
  /// ```
  ///
  AssertableJson whereNot(String key, dynamic unexpected) {
    final actual = getRequired(key);
    if (unexpected is Function) {
      expect(unexpected(actual), isFalse,
          reason: 'Property [$key] was marked as invalid using a closure');
    } else {
      expect(actual, isNot(equals(unexpected)),
          reason:
              'Property [$key] contains value that should be missing: $unexpected');
    }
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that multiple properties match their expected values.
  ///
  /// The [bindings] map contains key-value pairs where each key is a property
  /// name and each value is the expected value for that property.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Simple value matching
  /// json.whereAll({
  ///   'name': 'John',
  ///   'age': 30,
  ///   'isActive': true
  /// });
  ///
  /// // Mixed type matching
  /// json.whereAll({
  ///   'user': {'id': 1, 'role': 'admin'},
  ///   'permissions': ['read', 'write'],
  ///   'lastLogin': '2023-01-01'
  /// });
  ///
  /// // Using dot notation
  /// json.whereAll({
  ///   'user.profile.name': 'John',
  ///   'user.profile.age': 30,
  ///   'user.settings.theme': 'dark'
  /// });
  ///
  /// // Mixed standard and dot notation
  /// json.whereAll({
  ///   'id': 12345,
  ///   'user.profile.email': 'john@example.com',
  ///   'status': 'active'
  /// });
  /// ```
  ///
  AssertableJson whereAll(Map<String, dynamic> bindings) {
    bindings.forEach((key, value) => where(key, value));
    return this as AssertableJson;
  }

  /// Asserts that a property is of a specific type [T].
  ///
  /// The optional [key] specifies the property to check for type [T].
  /// If [key] is not provided, the root JSON data will be checked against [T].
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Check specific property types
  /// json.whereType`<String>`('name');
  /// json.whereType`<int>`('age');
  /// json.whereType`<List>`('hobbies');
  /// json.whereType`<Map>`('address');
  ///
  /// // Check root object type
  /// json.whereType`<Map>`();
  ///
  /// // Using dot notation
  /// json.whereType`<String>`('user.profile.name');
  /// json.whereType`<int>`('user.profile.age');
  /// json.whereType`<bool>`('user.settings.notifications');
  ///
  /// // With array elements
  /// json.whereType`<Map>`('posts.0');
  /// json.whereType`<String>`('tags.1');
  /// ```
  ///
  AssertableJson whereType<T>([String? key]) {
    if (key == null) {
      expect(json, isA<T>());
      return this as AssertableJson;
    }

    final actual = getRequired(key);
    expect(actual, isA<T>(),
        reason: 'Property [$key] is not of expected type [${T.toString()}]');
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that multiple properties are all of type [T].
  ///
  /// The [keys] list specifies the properties to check.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Check multiple string properties
  /// json.whereAllType`<String>`(['firstName', 'lastName', 'email']);
  ///
  /// // Check multiple numeric properties
  /// json.whereAllType`<int>`(['age', 'score', 'rank']);
  ///
  /// // Check multiple boolean properties
  /// json.whereAllType`<bool>`(['isActive', 'isVerified', 'hasAccess']);
  ///
  /// // Using dot notation
  /// json.whereAllType`<String>`([
  ///   'user.profile.firstName',
  ///   'user.profile.lastName',
  ///   'user.profile.email'
  /// ]);
  ///
  /// // With array elements
  /// json.whereAllType`<Map>`(['posts.0', 'posts.1', 'posts.2']);
  /// ```
  ///
  AssertableJson whereAllType<T>(List<String> keys) {
    for (var key in keys) {
      whereType<T>(key);
    }
    return this as AssertableJson;
  }

  /// Asserts that a property contains an expected value.
  ///
  /// For array properties, checks if [expected] is an element of the array.
  /// For string properties, checks if [expected] is a substring.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Array containment
  /// json.whereContains('tags', 'important');
  /// json.whereContains('permissions', 'admin');
  ///
  /// // Multiple values in array
  /// json.whereContains('permissions', ['read', 'write']);
  ///
  /// // String containment
  /// json.whereContains('description', 'test');
  /// json.whereContains('email', '@example.com');
  ///
  /// // Nested array containment
  /// json.whereContains('users', {'id': 1, 'name': 'John'});
  ///
  /// // Using dot notation
  /// json.whereContains('user.profile.bio', 'developer');
  /// json.whereContains('user.roles', 'admin');
  ///
  /// // With nested arrays
  /// json.whereContains('user.profile.tags', 'important');
  /// json.whereContains('posts.0.categories', 'news');
  /// ```
  ///
  AssertableJson whereContains(String key, dynamic expected) {
    final actual = getRequired(key);
    if (actual is List) {
      if (expected is List) {
        for (var value in expected) {
          expect(actual.contains(value), isTrue,
              reason: 'Expected $key to contain $value');
        }
      } else {
        expect(actual.contains(expected), isTrue,
            reason: 'Expected $key to contain $expected');
      }
    } else {
      expect(actual.toString().contains(expected.toString()), isTrue,
          reason: 'Property [$key] does not contain [$expected]');
    }
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that a property's value is one of the provided [values].
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Simple value inclusion
  /// json.whereIn('status', ['active', 'pending', 'completed']);
  /// json.whereIn('priority', [1, 2, 3]);
  ///
  /// // Using dot notation
  /// json.whereIn('user.status', ['active', 'verified']);
  /// json.whereIn('order.priority', [1, 2, 3]);
  ///
  /// // With array elements
  /// json.whereIn('posts.0.category', ['news', 'tech', 'sports']);
  /// json.whereIn('items.1.status', ['available', 'on_sale']);
  ///
  /// // Check that an array contains specified values
  /// json.whereIn('tags', ['important', 'urgent']);
  /// json.whereIn('user.roles', ['admin', 'moderator']);
  /// ```
  ///
  AssertableJson whereIn(String key, List<dynamic> values) {
    final actual = getRequired(key);
    if (actual is List) {
      for (var value in values) {
        expect(actual.contains(value), isTrue,
            reason:
                'Expected key `$key` to contain value $value, actual: $actual');
      }
    } else {
      expect(values.contains(actual), isTrue,
          reason: 'Expected $key to be one of $values');
    }

    interactsWith(key);
    return this as AssertableJson;
  }

  /// Asserts that a property's value is not one of the provided [values].
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Simple value exclusion
  /// json.whereNotIn('status', ['deleted', 'archived']);
  /// json.whereNotIn('errorCodes', [404, 500, 503]);
  ///
  /// // Using dot notation
  /// json.whereNotIn('user.status', ['banned', 'inactive']);
  /// json.whereNotIn('order.errorCode', [404, 500]);
  ///
  /// // With array elements
  /// json.whereNotIn('posts.0.category', ['removed', 'flagged']);
  /// json.whereNotIn('items.1.status', ['discontinued', 'out_of_stock']);
  ///
  /// // Check that an array doesn't contain specified values
  /// json.whereNotIn('tags', ['spam', 'hidden']);
  /// json.whereNotIn('user.roles', ['guest', 'blocked']);
  /// ```
  ///
  AssertableJson whereNotIn(String key, List<dynamic> values) {
    final actual = getRequired(key);
    if (actual is List) {
      for (var value in values) {
        expect(actual.contains(value), isFalse,
            reason:
                'Expected key `$key` to not contain value $value, actual: $actual');
      }
    } else {
      expect(values.contains(actual), isFalse,
          reason: 'Expected $key to not be one of $values');
    }
    interactsWith(key);
    return this as AssertableJson;
  }

  /// Validates that the JSON structure matches a given [schema].
  ///
  /// The [schema] map specifies property names and their expected types.
  /// Property names ending with '?' indicate optional fields.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Basic schema validation
  /// json.matchesSchema({
  ///   'id': int,
  ///   'name': String,
  ///   'email': String,
  ///   'age?': int,           // Optional field
  ///   'address?': Map,       // Optional field
  /// });
  ///
  /// // Complex schema validation
  /// json.matchesSchema({
  ///   'user': Map,
  ///   'posts': List,
  ///   'settings': Map,
  ///   'lastLoginDate': String,
  ///   'profileImage?': String,  // Optional field
  ///   'metadata?': Map,         // Optional field
  /// });
  ///
  /// // Validating specific types
  /// json.matchesSchema({
  ///   'id': int,
  ///   'name': String,
  ///   'isActive': bool,
  ///   'score': double,
  ///   'tags': List,
  ///   'config': Map,
  ///   'createdAt?': String,
  /// });
  ///
  /// // Using with nested objects
  /// // Note: For nested validation, use separate schema assertions
  /// json.has('user', (user) {
  ///   user.matchesSchema({
  ///     'id': int,
  ///     'profile': Map,
  ///     'roles': List
  ///   });
  /// });
  /// ```
  ///
  AssertableJson matchesSchema(Map<String, Type> schema) {
    schema.forEach((key, type) {
      final isOptional = key.endsWith('?');
      final actualKey = isOptional ? key.substring(0, key.length - 1) : key;

      try {
        (this as AssertableJson).has(actualKey);
        final value = get(actualKey);
        expect(value.runtimeType, equals(type),
            reason:
                'Expected $actualKey to be of type $type but was ${value.runtimeType}');
        interactsWith(actualKey);
      } catch (e) {
        if (!isOptional) {
          fail('Required field $actualKey is missing');
        }
      }
    });
    return this as AssertableJson;
  }
}
