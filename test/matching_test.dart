import 'package:assertable_json/src/assertable_json.dart' show AssertableJson;
import 'package:assertable_json/src/extensions/numeric_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('MatchingMixin', () {
    test('where matches exact value', () {
      final json = AssertableJson({'key': 'value'});
      json.where('key', 'value');
    });

    test('where with closure', () {
      final json = AssertableJson({'number': 5});
      json.where('number', (int value) => value.isGreaterThan(3));
    });

    test('whereNot matches non-equal value', () {
      final json = AssertableJson({'key': 'value'});
      json.whereNot('key', 'wrong');
    });

    test('whereNotIn matches non-equal value', () {
      final json = AssertableJson({
        'key': [1, 2, 3]
      });
      json.whereNotIn('key', [4, 5, 6]);
    });

    test('whereType matches correct type', () {
      final json = AssertableJson({'key': 'value'});
      json.whereType<String>('key');
    });

    test('whereContains matches substring', () {
      final json = AssertableJson({
        'key': 'test value',
        'list': [1, 2, 3]
      });
      json.whereContains('key', 'value');

      json.whereContains('list', [1, 2]);
    });

    test('whereIn matches value in list', () {
      final json = AssertableJson({
        'key': 2,
        'list': [1, 2, 3]
      });
      json.whereIn('key', [1, 2, 3]);
      json.whereIn('list', [1, 2, 3]);
    });

    test('matchesSchema verifies type structure', () {
      final json = AssertableJson({'string': 'value', 'number': 42});

      json.matchesSchema({'string': String, 'number': int});
    });
    test('matchesSchema handles optional fields', () {
      final json = AssertableJson({'required': 'value'});

      // Should pass - optional field can be missing
      json.matchesSchema({
        'required': String,
        'optional?': int,
      });

      // Should pass - optional field can be present
      final jsonWithOptional = AssertableJson({
        'required': 'value',
        'optional': 42,
      });
      jsonWithOptional.matchesSchema({
        'required': String,
        'optional?': int,
      });
    });

    test('matchesSchema fails on missing required field', () {
      final json = AssertableJson({'optional': 42});

      expect(
        () => json.matchesSchema({
          'required': String,
          'optional?': int,
        }),
        throwsA(anything),
      );
    });
  });
}
