import 'package:test/expect.dart';

import 'assertable_json.dart';

/// A mixin that tracks property access in JSON objects and provides verification
/// capabilities.
///
/// This mixin maintains a set of accessed property keys and offers methods to:
/// * Track which properties have been accessed
/// * Verify that all properties have been interacted with
/// * Mark all properties as accessed
///
/// Example usage:
///
/// ```dart
/// class MyJson with InteractionMixin {
///   final Map<String, dynamic> _json;
///
///   @override
///   dynamic get json => _json;
///
///   void validateAllPropertiesAccessed() {
///     verifyInteracted();
///   }
/// }
///
/// // Usage example
/// final jsonData = {'name': 'John', 'age': 30, 'email': 'john@example.com'};
/// final myJson = MyJson(jsonData);
/// myJson.has('name').has('age'); // Access some properties
/// myJson.verifyInteracted(); // This will fail because 'email' wasn't accessed
/// ```
///
mixin InteractionMixin {
  final Set<String> _interacted = {};

  dynamic get json;

  /// Records an interaction with the specified JSON property [key].
  ///
  /// For non-List JSON objects, tracks the root property name when accessing
  /// nested properties using dot notation. This ensures that property tracking
  /// works correctly even when using dot notation for deep property access.
  ///
  /// Example:
  ///
  /// ```dart
  /// // When accessing a nested property like 'user.profile.name'
  /// // only the root key 'user' is marked as interacted
  /// json.has('user.profile.name');
  /// ```
  void interactsWith(String key) {
    if (json is! List) {
      // For dot notation, we track the root property
      final prop = key.split('.').first;
      _interacted.add(prop);
    }
  }

  /// Verifies that all properties in the JSON object have been accessed.
  ///
  /// Throws a [TestFailure] if any properties have not been interacted with.
  /// Only applies to non-List JSON objects. This is useful for ensuring complete
  /// coverage of JSON response testing, making sure no fields are overlooked.
  ///
  /// Example:
  ///
  /// ```dart
  /// // Basic usage to ensure all properties were checked
  /// final json = AssertableJson({'user': {...}, 'posts': [...]});
  /// json.has('user').has('posts');
  /// json.verifyInteracted(); // Passes because all root properties were accessed
  ///
  /// // With dot notation
  /// final json = AssertableJson({'user': {...}, 'posts': [...]});
  /// json.has('user.name');
  /// // This will fail because 'posts' wasn't accessed
  /// json.verifyInteracted();
  /// ```
  void verifyInteracted() {
    if (json is! List && json is Map) {
      final jsonKeys = json.keys.toSet();
      // If we've interacted with all keys, or the set is empty, return early
      if (_interacted.containsAll(jsonKeys) || jsonKeys.isEmpty) {
        return;
      }

      final unInteractedKeys = jsonKeys.difference(_interacted);
      expect(unInteractedKeys.isEmpty, isTrue,
          reason: 'Unexpected properties were found: $unInteractedKeys');
    }
  }

  /// Marks all properties in the JSON object as accessed.
  ///
  /// This method is useful when you want to acknowledge all remaining properties
  /// without explicitly asserting each one. It effectively tells the test that
  /// you're aware of these properties but don't need to verify them individually.
  ///
  /// Returns this instance as an [AssertableJson] for method chaining.
  /// Only applies to non-List JSON objects.
  ///
  /// Example:
  ///
  /// ```dart
  /// // Only check certain properties and ignore the rest
  /// final json = AssertableJson({
  ///   'id': 123,
  ///   'name': 'John',
  ///   'email': 'john@example.com',
  ///   'createdAt': '2023-01-01',
  ///   'updatedAt': '2023-02-01'
  /// });
  ///
  /// json
  ///   .has('id')
  ///   .has('name')
  ///   // Mark all other properties as accessed without explicit checks
  ///   .etc();
  ///
  /// // This will now pass even though we didn't explicitly check email, createdAt, and updatedAt
  /// json.verifyInteracted();
  /// ```
  AssertableJson etc() {
    if (json is! List) {
      _interacted.addAll(json.keys);
    }
    return this as AssertableJson;
  }
}
