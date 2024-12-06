import 'package:json_contains/json_contains.dart' as jc;

extension JsonContainsMapExtension on Map<String, dynamic> {
  bool containsJson(Map<String, dynamic> jsonToContain) => jc.jsonContains(
        json: this,
        jsonToContain: jsonToContain,
      );
}
