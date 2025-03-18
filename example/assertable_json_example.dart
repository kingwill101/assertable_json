import 'package:assertable_json/assertable_json.dart';
import 'package:assertable_json/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('API Response Testing Examples', () {
    test('Testing user profile response', () {
      // Simulate an API response
      final userResponse = {
        'status': 'success',
        'data': {
          'user': {
            'id': 123,
            'name': 'John Doe',
            'email': 'john@example.com',
            'age': 30,
            'isActive': true,
            'roles': ['admin', 'user'],
            'settings': {'notifications': true, 'theme': 'dark'},
            'scores': [85, 92, 78],
            'lastLogin': '2024-01-15T10:30:00Z'
          }
        },
        'meta': {'timestamp': 1705312200, 'version': '1.0'}
      };

      // Create AssertableJson instance
      final json = AssertableJson(userResponse);

      // Test response structure and values
      json
          // Top level structure
          .has('status')
          .has('data')
          .has('meta')
          .whereType<String>('status')
          .where('status', 'success')

          // User object testing
          .scope('data', (AssertableJson data) {
        data.has('user', (AssertableJson user) {
          user
              // Basic property checks
              .has('id')
              .has('name')
              .has('email')
              .has('age')
              .has('isActive')
              .has('roles')
              .has('settings')
              .has('scores')
              .has('lastLogin')

              // Type validations
              .whereType<int>('id')
              .whereType<String>('name')
              .whereType<String>('email')
              .whereType<int>('age')
              .whereType<bool>('isActive')
              .whereType<List>('roles')
              .whereType<Map>('settings')
              .whereType<List>('scores')
              .whereType<String>('lastLogin')

              // Value validations
              .isGreaterThan('id', 0)
              .isGreaterThan('age', 18)
              .whereContains('email', '@')
              .where('isActive', true)

              // Array testing
              .count('roles', 2)
              .count('scores', 3)

              // Testing array contents
              .scope('roles', (roles) {
            roles.each((AssertableJson role) {
              role.whereType<String>();
            });
          })

              // Testing numeric array
              .scope('scores', (scores) {
            scores.each((score) {
              score.whereType<int>();
              (score.json as int).assertGreaterOrEqual(0);
              (score.json as int).assertLessOrEqual(100);
            });
          })

              // Nested object testing
              .scope('settings', (settings) {
            settings
                .has('notifications')
                .has('theme')
                .whereType<bool>('notifications')
                .whereType<String>('theme')
                .where('theme', 'dark');
          });
        });
      })

          // Meta information testing
          .scope('meta', (meta) {
        meta
            .has('timestamp')
            .has('version')
            .whereType<int>('timestamp')
            .whereType<String>('version')
            .where('version', '1.0');
      });
    });

    test('Testing JSON string response', () {
      // Simulate a JSON string response
      final jsonString = '''
      {
        "products": [
          {
            "id": 1,
            "name": "Product 1",
            "price": 29.99,
            "inStock": true
          },
          {
            "id": 2,
            "name": "Product 2",
            "price": 49.99,
            "inStock": false
          }
        ],
        "total": 2,
        "hasMore": false
      }
      ''';

      // Create AssertableJsonString instance
      final response = AssertableJsonString(jsonString);

      // Test the structure and content
      response
          // Check total count of root properties
          .assertCount(3)

          // Verify the structure matches expected schema
          .assertStructure({
        'products': {
          '*': ['id', 'name', 'price', 'inStock']
        },
        'total': null, //
        'hasMore': null
      })

          // Verify specific data fragments
          .assertFragment({'total': 2, 'hasMore': false});
    });

    test('Demonstrating conditional testing', () {
      final adminResponse = {
        'user': {
          'name': 'Admin User',
          'role': 'admin',
          'permissions': ['read', 'write', 'delete']
        }
      };

      final json = AssertableJson(adminResponse);

      // Conditional testing based on role
      json.scope('user', (user) {
        final isAdmin = user.get<String>('role') == 'admin';

        user.has('name').has('role').when(isAdmin, (json) {
          json
              .has('permissions')
              .count('permissions', 3)
              .whereContains('permissions', 'delete');
        });
      });
    });

    test('Testing numeric validations', () {
      final data = {
        'stats': {
          'count': 100,
          'average': 4.5,
          'rating': 5,
          'temperature': -10,
          'price': 99.99
        }
      };

      final json = AssertableJson(data);

      json.scope('stats', (stats) {
        stats
            // Basic numeric comparisons
            .isGreaterThan('count', 0)
            .isLessThan('count', 1000)
            .isBetween('rating', 1, 5)
            .isNegative('temperature')
            .isPositive('price')

            // Mathematical validations
            .isDivisibleBy('count', 10)
            .isMultipleOf('count', 25)
            .etc();
      });
    });
  });
}
