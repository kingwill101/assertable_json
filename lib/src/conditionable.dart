import 'package:assertable_json/src/assertable_json.dart';

/// A mixin that provides conditional assertion methods for JSON testing.
///
/// This mixin adds methods that allow conditional execution of assertions based on
/// boolean conditions. It enables more flexible and dynamic testing scenarios by
/// allowing assertions to be executed only when specific conditions are met.
///
/// Examples:
///
/// ```dart
/// // Basic conditional assertions
/// json.when(isAdmin, (json) => json
///   .has('adminPrivileges')
///   .has('role', 'admin'));
///
/// // Using with logical expressions
/// json.when(user.age >= 18, (json) => json
///   .has('adult')
///   .missing('guardian'));
///
/// // Using with variable conditions
/// final hasPermission = json.get('permissions.edit') == true;
/// json.when(hasPermission, (json) => json
///   .has('canEdit')
///   .has('editHistory'));
///
/// // Chaining conditionals
/// json
///   .when(isAdmin, (json) => json.has('adminSection'))
///   .when(isPremium, (json) => json.has('premiumFeatures'));
/// ```
mixin ConditionableMixin {
  /// Executes the [callback] on this [AssertableJson] instance when the [condition] is true.
  ///
  /// Returns this instance to allow method chaining.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Simple condition with a single assertion
  /// json.when(isAdmin, (json) => json.has('adminField'));
  ///
  /// // Multiple assertions in the callback
  /// json.when(isVerified, (json) => json
  ///   .has('verificationDate')
  ///   .has('verifiedBy')
  ///   .whereType<String>('verificationId'));
  ///
  /// // Using with computed conditions
  /// json.when(
  ///   json.get<int>('age')! >= 18,
  ///   (json) => json.has('canVote')
  /// );
  ///
  /// // Nested conditions
  /// json.when(hasAccess, (json) => json
  ///   .has('accessLevel')
  ///   .when(isAdmin, (json) => json.has('adminRights')));
  /// ```
  AssertableJson when(bool condition, Function(AssertableJson) callback) {
    if (condition) {
      callback(this as AssertableJson);
    }
    return this as AssertableJson;
  }

  /// Executes the [callback] on this [AssertableJson] instance when the [condition] is false.
  ///
  /// Returns this instance to allow method chaining.
  ///
  /// Examples:
  ///
  /// ```dart
  /// // Simple negated condition
  /// json.unless(isAdmin, (json) => json.missing('adminField'));
  ///
  /// // Multiple assertions in the callback
  /// json.unless(isVerified, (json) => json
  ///   .has('pendingVerification')
  ///   .has('verificationReminder'));
  ///
  /// // Using with computed conditions
  /// json.unless(
  ///   json.get<int>('score')! > 70,
  ///   (json) => json.has('needsImprovement')
  /// );
  ///
  /// // Combined with when() for if/else like behavior
  /// json
  ///   .when(isActive, (json) => json.has('activeUntil'))
  ///   .unless(isActive, (json) => json.has('inactiveReason'));
  /// ```
  AssertableJson unless(bool condition, Function(AssertableJson) callback) {
    if (!condition) {
      callback(this as AssertableJson);
    }
    return this as AssertableJson;
  }
}
