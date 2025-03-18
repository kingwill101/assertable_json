# AssertableJson

A powerful, fluent JSON testing utility for Dart that makes it easy to write expressive and readable assertions for JSON data structures.

## Features

- 🔍 **Property Validation**: Assert presence/absence of keys, nested properties, and values
- 📐 **Type Checking**: Verify types with strong type safety
- 🔢 **Numeric Assertions**: Compare numbers, check ranges, validate mathematical properties
- 🎯 **Pattern Matching**: Test values against patterns and custom conditions
- 📦 **Schema Validation**: Validate JSON structure against expected schemas
- 🎭 **Conditional Testing**: Execute assertions based on conditions
- 🔄 **Chain Operations**: Fluent API for chaining multiple assertions
- 🎨 **JSON String Testing**: Special support for testing JSON string responses

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  assertable_json: ^1.0.0
```

## Basic Usage

```dart
import 'package:assertable_json/assertable_json.dart';

void main() {
  test('verify user data', () {
    final json = AssertableJson({
      'user': {
        'id': 123,
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30,
        'roles': ['admin', 'user']
      }
    });

    json
      .has('user', (user) => user
        .has('id')
        .whereType<int>('id')
        .has('name')
        .whereType<String>('name')
        .has('email')
        .whereContains('email', '@')
        .has('age')
        .isGreaterThan('age', 18)
        .has('roles')
        .count('roles', 2));
  });
}
```

## Key Features in Detail

### Property Assertions

```dart
json
  .has('name')               // Verify key exists
  .hasNested('user.email')   // Check nested properties
  .hasAll(['id', 'name'])    // Check multiple properties
  .missing('deletedAt');     // Verify key doesn't exist
```

### Numeric Validations

```dart
json
  .isGreaterThan('age', 18)
  .isLessThan('price', 100)
  .isBetween('rating', 1, 5)
  .isDivisibleBy('count', 5)
  .isPositive('score');
```

### Type & Pattern Matching

```dart
json
  .whereType<String>('email')
  .whereContains('email', '@')
  .whereIn('status', ['active', 'pending'])
  .where('age', (value) => value >= 18);
```

### Schema Validation

```dart
json.matchesSchema({
  'id': int,
  'name': String,
  'email': String,
  'age': int,
  'optional?': String  // Optional field
});
```

### Conditional Testing

```dart
json
  .when(isAdmin, (json) {
    json.has('adminPrivileges');
  })
  .unless(isGuest, (json) {
    json.has('personalInfo');
  });
```

### JSON String Testing

When working with JSON string responses:

```dart
final response = AssertableJsonString('{"status": "success", "data": {"id": 1}}');

response
  .assertCount(2)
  .assertFragment({'status': 'success'})
  .assertStructure({
    'status': String,
    'data': {
      'id': int
    }
  });
```

### Array Testing

```dart
json
  .has('items', 3, (items) {
    items.each((item) {
      item
        .has('id')
        .has('name')
        .whereType<bool>('active');
    });
  });
```

## Additional Features

- **Property Tracking**: Automatically tracks which properties have been tested
- **Debugging**: Built-in debugging tools with `dd()` and `printR()`
- **Custom Assertions**: Extend with your own assertion methods
- **Type Safety**: Full type safety with Dart's static typing
- **Fluent API**: Chain multiple assertions for cleaner code
- **Detailed Errors**: Clear error messages for failed assertions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
