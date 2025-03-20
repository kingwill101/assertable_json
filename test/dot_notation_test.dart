import 'package:assertable_json/src/assertable_json.dart';
import 'package:test/test.dart';

void main() {
  late AssertableJson json;

  setUp(() {
    json = AssertableJson({
      'user': {
        'profile': {
          'negative': -1,
          'name': {'first': 'John', 'last': 'Doe'},
          'age': 30,
          'tags': ['developer', 'dart'],
          'scores': [85, 90, 95],
          'active': true,
          'rating': 4.5
        },
        'settings': {
          'notifications': true,
          'theme': 'dark',
          'favorites': [1, 2, 3]
        }
      },
      'posts': [
        {'id': 1, 'title': 'First Post', 'comments': 5},
        {'id': 2, 'title': 'Second Post', 'comments': 10}
      ],
      'stats': {'views': 100, 'likes': 25, 'dislikes': -5, 'multiplier': 2.5}
    });
  });

  group('HasMixin with dot notation', () {
    test('has() accesses nested properties', () {
      json.has('user.profile.name.first');
      json.has('user.settings.notifications');
      json.has('posts.0.id');
    });

    test('hasNested() works with dot notation', () {
      json.hasNested('user.profile.name.first');
      json.hasNested('user.settings.theme');
      json.hasNested('posts.1.comments');
    });

    test('hasAll() works with dot notation paths', () {
      json.hasAll([
        'user.profile.name.first',
        'user.profile.name.last',
        'user.settings.theme'
      ]);
    });

    test('count() works with dot notation', () {
      json.count('user.profile.tags', 2);
      json.count('user.settings.favorites', 3);
      json.count('posts', 2);
    });

    test('countBetween() works with dot notation', () {
      json.countBetween('user.profile.tags', 1, 3);
      json.countBetween('posts', 1, 3);
    });

    test('missing() works with dot notation', () {
      json.missing('user.profile.nonexistent');
      json.missing('posts.3');
    });

    test('missingAll() works with dot notation', () {
      json.missingAll([
        'user.profile.nonexistent',
        'user.settings.unknown',
        'nonexistent.key'
      ]);
    });
  });

  group('MatchingMixin with dot notation', () {
    test('where() with dot notation', () {
      json.where('user.profile.name.first', 'John');
      json.where('user.profile.age', 30);
      json.where('stats.views', 100);
    });

    test('where() with closure and dot notation', () {
      json.where('user.profile.age', (value) => value > 20 && value < 40);
      json.where('stats.views', (value) => value == 100);
    });

    test('whereNot() with dot notation', () {
      json.whereNot('user.profile.name.first', 'Jane');
      json.whereNot('user.profile.age', 25);
    });

    test('whereAll() with dot notation', () {
      json.whereAll({
        'user.profile.name.first': 'John',
        'user.profile.name.last': 'Doe',
        'user.profile.age': 30
      });
    });

    test('whereType() with dot notation', () {
      json.whereType<String>('user.profile.name.first');
      json.whereType<int>('user.profile.age');
      json.whereType<bool>('user.profile.active');
      json.whereType<List>('user.profile.tags');
      json.whereType<Map>('user.profile');
    });

    test('whereAllType() with dot notation', () {
      json.whereAllType<String>([
        'user.profile.name.first',
        'user.profile.name.last',
        'user.settings.theme'
      ]);
    });

    test('whereContains() with dot notation', () {
      json.whereContains('user.profile.name.first', 'Jo');
      json.whereContains('user.profile.tags', 'dart');
    });

    test('whereIn() with dot notation', () {
      json.whereIn('user.profile.age', [25, 30, 35]);
      json.whereIn('user.settings.theme', ['light', 'dark', 'system']);
    });

    test('whereNotIn() with dot notation', () {
      json.whereNotIn('user.profile.age', [25, 35, 40]);
      json.whereNotIn('user.settings.theme', ['light', 'system']);
    });
  });

  group('ConditionMixin with dot notation', () {
    test('isGreaterThan() with dot notation', () {
      json.isGreaterThan('user.profile.age', 25);
      json.isGreaterThan('stats.views', 50);
      json.isGreaterThan('posts.1.comments', 5);
    });

    test('isLessThan() with dot notation', () {
      json.isLessThan('user.profile.age', 35);
      json.isLessThan('stats.views', 150);
    });

    test('isGreaterOrEqual() with dot notation', () {
      json.isGreaterOrEqual('user.profile.age', 30);
      json.isGreaterOrEqual('stats.views', 100);
    });

    test('isLessOrEqual() with dot notation', () {
      json.isLessOrEqual('user.profile.age', 30);
      json.isLessOrEqual('stats.views', 100);
    });

    test('equals() with dot notation', () {
      json.equals('user.profile.age', 30);
      json.equals('stats.views', 100);
    });

    test('notEquals() with dot notation', () {
      json.notEquals('user.profile.age', 25);
      json.notEquals('stats.views', 50);
    });

    test('isDivisibleBy() with dot notation', () {
      json.isDivisibleBy('stats.views', 10);
      json.isDivisibleBy('stats.likes', 5);
    });

    test('isMultipleOf() with dot notation', () {
      json.isMultipleOf('stats.views', 25);
      json.isMultipleOf('posts.0.comments', 5);
    });

    test('isBetween() with dot notation', () {
      json.isBetween('user.profile.age', 25, 35);
      json.isBetween('stats.views', 50, 150);
    });

    test('isPositive() with dot notation', () {
      json.isPositive('user.profile.age');
      json.isPositive('stats.views');
    });

    test('isNegative() with dot notation', () {
      json.isNegative('user.profile.negative');
      json.isNegative('stats.dislikes');
    });
  });

  group('ConditionableMixin with dot notation', () {
    test('when() condition with dot notation access', () {
      var executed = false;

      json.when(json.get<int>('user.profile.age')! > 25, (json) {
        executed = true;
      });

      expect(executed, isTrue);
    });

    test('unless() condition with dot notation access', () {
      var executed = false;

      json.unless(json.get<int>('user.profile.age')! < 25, (json) {
        executed = true;
      });

      expect(executed, isTrue);
    });
  });

  group('InteractionMixin with dot notation', () {
    test('only tracks root keys during dot notation access', () {
      json
          .has('user.profile.name.first')
          .where('user.profile.age', 30)
          .has('posts.0.id')
          .has('stats.views'); // Access all three root keys

      // This should pass as we've interacted with all root keys
      json.verifyInteracted();
    });

    test('marks only the root property as interacted', () {
      // Create a new JSON with just the 'user' property
      final userJson = AssertableJson({'user': json.json['user']});

      // Access a nested property
      userJson.has('user.profile.name.first');

      // This should pass because we've interacted with the 'user' key
      userJson.verifyInteracted();
    });
  });

  group('Complex dot notation scenarios', () {
    test('nested array access with dot notation', () {
      json.has('posts.0.id');
      json.where('posts.0.id', 1);
      json.where('posts.1.title', 'Second Post');
    });

    test('chained assertions with dot notation', () {
      json
          .has('user.profile')
          .whereType<Map>('user.profile')
          .has('user.profile.name.first')
          .where('user.profile.name.first', 'John')
          .whereContains('user.profile.tags', 'dart')
          .isGreaterThan('user.profile.age', 25);
    });

    test('mixed dot and regular notation', () {
      json
          .has('user')
          .has('user.profile')
          .has('user.profile.name')
          .has('user.profile.name.first');
    });
  });
}
