
import 'package:assertable_json/src/assertable_json.dart' show AssertableJson;

/// A mixin that provides tap functionality for [AssertableJson] objects.
///
/// Allows chaining assertions by tapping into the current state of an [AssertableJson]
/// object, performing operations via the callback, and returning the object for
/// further assertions.
mixin TappableMixin {
  AssertableJson tap(Function(AssertableJson) callback) {
    callback(this as AssertableJson);
    return this as AssertableJson;
  }
}
