import 'package:test/test.dart';
import 'package:collection/collection.dart';

import '../assertable_json.dart';

/// Matcher that checks if a JSON object contains the given [path].
/// If [expected] is provided the value must also match.
Matcher hasJsonPath(String path, [dynamic expected]) =>
    _HasJsonPathMatcher(path, expected);

/// Matcher that checks a JSON object contains all key/value pairs
/// in [fragment].
Matcher jsonContainsFragment(Map<String, dynamic> fragment) =>
    _JsonFragmentMatcher(fragment);

/// Matcher that checks two JSON objects are deeply equal after sorting keys.
Matcher jsonEquals(Map<String, dynamic> expected) =>
    _JsonEqualsMatcher(expected);

Map<String, dynamic> _deepSort(Map<String, dynamic> map) {
  final sorted = Map<String, dynamic>.from(map);
  sorted.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      sorted[key] = _deepSort(value);
    }
  });
  final entries = sorted.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return Map.fromEntries(entries);
}

class _HasJsonPathMatcher extends Matcher {
  final String path;
  final dynamic expected;

  const _HasJsonPathMatcher(this.path, [this.expected]);

  @override
  Description describe(Description description) {
    return description.add('has JSON path [$path]' +
        (expected != null ? ' with value $expected' : ''));
  }

  @override
  bool matches(dynamic item, Map matchState) {
    final json = AssertableJson(item);
    if (!json.exists(path)) {
      matchState['reason'] = 'Property [$path] does not exist';
      return false;
    }

    if (expected != null) {
      var actual = json.get(path);
      var exp = expected;
      if (exp is Map<String, dynamic>) {
        exp = _deepSort(Map<String, dynamic>.from(exp));
        if (actual is Map<String, dynamic>) {
          actual = _deepSort(Map<String, dynamic>.from(actual));
        }
      }

      final equals = const DeepCollectionEquality().equals(actual, exp);
      if (!equals) {
        matchState['reason'] =
            'Expected [$path] to be $expected but was $actual';
        return false;
      }
    }
    return true;
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    final reason = matchState['reason'];
    if (reason != null) mismatchDescription.add(reason);
    return mismatchDescription;
  }
}

class _JsonFragmentMatcher extends Matcher {
  final Map<String, dynamic> fragment;

  const _JsonFragmentMatcher(this.fragment);

  @override
  Description describe(Description description) =>
      description.add('contains JSON fragment $fragment');

  @override
  bool matches(dynamic item, Map matchState) {
    final json = AssertableJson(item);
    for (final entry in fragment.entries) {
      if (!json.exists(entry.key)) {
        matchState['reason'] = 'Missing key ${entry.key}';
        return false;
      }

      var expectedValue = entry.value;
      var actual = json.get(entry.key);
      if (expectedValue is Map<String, dynamic>) {
        expectedValue = _deepSort(Map<String, dynamic>.from(expectedValue));
        if (actual is Map<String, dynamic>) {
          actual = _deepSort(Map<String, dynamic>.from(actual));
        }
      }

      final equals =
          const DeepCollectionEquality().equals(actual, expectedValue);
      if (!equals) {
        matchState['reason'] =
            'Value mismatch for key ${entry.key}: expected ${entry.value} got $actual';
        return false;
      }
    }
    return true;
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    final reason = matchState['reason'];
    if (reason != null) mismatchDescription.add(reason);
    return mismatchDescription;
  }
}

class _JsonEqualsMatcher extends Matcher {
  final Map<String, dynamic> expected;
  const _JsonEqualsMatcher(this.expected);

  @override
  Description describe(Description description) =>
      description.add('equals JSON $expected');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Map<String, dynamic>) {
      matchState['reason'] = 'Item is not a Map';
      return false;
    }
    final sortedActual = _deepSort(Map<String, dynamic>.from(item));
    final sortedExpected = _deepSort(Map<String, dynamic>.from(expected));
    if (const DeepCollectionEquality().equals(sortedActual, sortedExpected)) {
      return true;
    }
    matchState['reason'] = 'JSON mismatch';
    return false;
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    final reason = matchState['reason'];
    if (reason != null) mismatchDescription.add(reason);
    return mismatchDescription;
  }
}
