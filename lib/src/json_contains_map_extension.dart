import 'package:json_contains/src/json_contains_base.dart';

extension JsonContainsMapExtension on Map<String, dynamic> {
  bool containsJson(Map<String, dynamic> jsonToContain) => jsonContains(
        json: this,
        jsonToContain: jsonToContain,
      );
}
