import 'package:assertable_json/assertable_json.dart';
import 'package:test/test.dart';

void main() {
  group('Custom Matchers', () {
    test('hasJsonPath success', () {
      final data = {'user': {'id': 1}};
      expect(data, hasJsonPath('user.id'));
    });

    test('hasJsonPath with value', () {
      final data = {'id': 5};
      expect(data, hasJsonPath('id', 5));
    });

    test('jsonContainsFragment success', () {
      final data = {'id': 1, 'name': 'Item'};
      expect(data, jsonContainsFragment({'name': 'Item'}));
    });

    test('jsonEquals success', () {
      final data = {'a': 1, 'b': {'c': 2}};
      expect(data, jsonEquals({'b': {'c': 2}, 'a': 1}));
    });
  });
}
