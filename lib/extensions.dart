/// Extension methods for enhanced numeric testing capabilities.
///
/// This library provides two main sets of extensions:
/// * Numeric assertions for test validation
/// * Numeric utility methods for common mathematical operations
///
/// Example usage:
/// ```dart
/// // Using assertion extensions in tests
/// 25.assertGreaterThan(20);
/// 15.assertBetween(10, 20);
/// 16.assertEven();
///
/// // Using utility extensions
/// if (number.isGreaterThan(20) && number.isPrime()) {
///   // Do something
/// }
/// ```
library;

export 'src/extensions/extensions.dart';
