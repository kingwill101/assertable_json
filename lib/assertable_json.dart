/// A powerful, fluent JSON testing utility for Dart that makes it easy to write
/// expressive and readable assertions for JSON data structures.
///
/// This library provides two main classes for JSON testing:
/// * [AssertableJson] - For testing JSON data structures and objects
/// * [AssertableJsonString] - For testing JSON string responses
///
/// Core features include:
/// * Property validation
/// * Type checking
/// * Numeric assertions
/// * Pattern matching
/// * Schema validation
/// * Conditional testing
/// * Fluent API for chaining assertions
///
/// Example usage:
/// ```dart
/// final json = AssertableJson({
///   'user': {
///     'id': 123,
///     'name': 'John Doe',
///     'email': 'john@example.com',
///     'age': 30
///   }
/// });
///
/// json
///   .has('user', (user) => user
///     .has('id')
///     .whereType<int>('id')
///     .has('name')
///     .whereType<String>('name')
///     .has('email')
///     .whereContains('email', '@')
///     .has('age')
///     .isGreaterThan('age', 18));
/// ```
library;

export 'src/assertable_json.dart';
export 'src/assertable_json_base.dart';
export 'src/assertable_json_string.dart';
