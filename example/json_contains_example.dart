import 'package:json_contains/json_contains.dart';

void main() {
  // Sample JSON object
  final json = {
    "name": "John",
    "age": 30,
    "address": {"street": "Main Street", "city": "New York"}
  };

  // JSON to check if it is contained
  final jsonToContain = {
    "name": "John",
    "address": {"city": "New York"}
  };

  // Call the jsonContains function
  final result = jsonContains(json: json, jsonToContain: jsonToContain);

  if (result) {
    print("The JSON object contains the specified fields and values.");
  } else {
    print("The JSON object does not contain the specified fields and values.");
  }
}
