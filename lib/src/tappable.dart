import 'package:assertable_json/src/assertable_json.dart' show AssertableJson;

/// A mixin that provides tap functionality for [AssertableJson] objects.
///
/// Allows chaining assertions by tapping into the current state of an [AssertableJson]
/// object, performing operations via the callback, and returning the object for
/// further assertions.
mixin TappableMixin {
  /// Executes the provided [callback] function on the current [AssertableJson] instance
  /// and returns the instance to enable method chaining.
  ///
  /// This method allows you to perform a series of operations on the current JSON object
  /// without breaking the chain of method calls. It's especially useful for organizing
  /// complex assertion logic or for creating reusable assertion patterns.
  ///
  /// The [callback] parameter is a function that takes an [AssertableJson] instance
  /// and performs operations on it.
  ///
  /// Examples:
  ///
  /// Basic usage with a simple callback:
  /// ```dart
  /// json.tap((obj) {
  ///   // Perform operations on the JSON object
  ///   obj.has('id').has('name');
  /// }).has('email'); // Continue chaining after the tap
  /// ```
  /// Returns the current [AssertableJson] instance to allow method chaining.
  AssertableJson tap(Function(AssertableJson) callback) {
    callback(this as AssertableJson);
    return this as AssertableJson;
  }
}
