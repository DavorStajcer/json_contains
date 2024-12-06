import 'dart:developer';

import 'package:json_contains/json_contains.dart';

/// Used for comparing if a JSON object contains another JSON object.
/// Specifically, if [json] contains all the fields and values that are in [jsonToContain].
///
/// E.g. if [json] is:
/// ```json
/// {
///   "name": "John",
///   "age": 30,
///   "address": {
///     "street": "Main Street",
///     "city": "New York"
///    }
/// }
/// ```
/// and [jsonToContain] is:
/// ```json
/// {
///   "name": "John",
///   "address": {
///     "city": "New York"
///   }
/// }
///
/// ```
///
/// Then [json] contains [jsonToContain] as all the fields and values in [jsonToContain] are in [json].
///
/// [listBehavior] defines the behavior when comparing if a JSON list contains another JSON list.
///
/// By default when two lists are compared:
/// - lenght of the lists is not compared
/// - ordering of items is not compared
bool jsonContains({
  required Map<String, dynamic> json,
  required Map<String, dynamic> jsonToContain,
  JsonContainsListBehavior listBehavior = const JsonContainsListBehavior(),
  bool debugLog = false,
}) {
  try {
    _throwIfNotAllWantedReceived(json, jsonToContain, listBehavior);
    return true;
  } catch (e) {
    if (debugLog) {
      log('json_contains: $e');
    }
    return false;
  }
}

/// Throws if any value that is in [jsonToContain] is not in [json]
/// [json] can contain more values than [jsonToContain] - this is ignored.
_throwIfNotAllWantedReceived(
  Map<String, dynamic> json,
  Map<String, dynamic> jsonToContain,
  JsonContainsListBehavior listBehavior,
) {
  for (var e in jsonToContain.keys) {
    final containValue = jsonToContain[e];
    final value = json[e];
    _compareJsonValues(key: e, value: value, containValue: containValue, listBehavior: listBehavior);
  }
}

_compareJsonValues({
  String? key,
  required dynamic value,
  required dynamic containValue,
  required JsonContainsListBehavior listBehavior,
}) {
  if (containValue is Map<String, dynamic>) {
    /// We want to allow the type cast to throw - this is the expected behavior as we throw if values are not equal.
    _throwIfNotAllWantedReceived(value as Map<String, dynamic>, containValue, listBehavior);
    return;
  }
  if (containValue is List<dynamic>) {
    /// We want to allow the type cast to throw - this is the expected behavior as we throw if values are not equal.
    _onJsonListValue(key, value as List<dynamic>, containValue, listBehavior);
    return;
  }
  if (containValue != value) {
    throw Exception('Not all wanted values received - wanted: $containValue, received: $value');
  }
}

_onJsonListValue(
  String? key,
  List<dynamic> value,
  List<dynamic> containValue,
  JsonContainsListBehavior listBehavior,
) {
  if (listBehavior.compareLenght) {
    _throwIfNotSameLenght(key, value, containValue);
  }
  if (listBehavior.compareOrder) {
    _compareJsonListInOrder(key, containValue, value, listBehavior);
    return;
  }
  _compareJsonList(key, containValue, value, listBehavior);
}

_throwIfNotSameLenght(
  String? key,
  List<dynamic> value,
  List<dynamic> containValue,
) {
  if (value.length != containValue.length) {
    final forKey = key == null ? '' : ' for key: $key';
    throw Exception('When comparing two lists$forKey, the lenghts are not the same - wanted: ${containValue.length}, received: ${value.length}');
  }
}

void _compareJsonListInOrder(
  String? key,
  List<dynamic> containList,
  List<dynamic> list,
  JsonContainsListBehavior listBehavior,
) {
  for (var (i, containValue) in containList.indexed) {
    final value = list[i];
    _compareJsonValues(key: key, value: value, containValue: containValue, listBehavior: listBehavior);
  }
}

void _compareJsonList(
  String? key,
  List<dynamic> containList,
  List<dynamic> list,
  JsonContainsListBehavior listBehavior,
) {
  for (var containValue in containList) {
    final isContained = _listContainsValue(list, containValue, listBehavior);
    if (!isContained) {
      throw Exception('Not all wanted values received - wanted: $containValue, received: $list');
    }
  }
}

bool _listContainsValue(
  List<dynamic> list,
  dynamic containValue,
  JsonContainsListBehavior listBehavior,
) {
  for (var value in list) {
    final isEqual = _isListItemEqual(value, containValue, listBehavior);
    if (isEqual) {
      return true;
    }
  }
  return false;
}

bool _isListItemEqual(value, containValue, JsonContainsListBehavior listBehavior) {
  try {
    _compareJsonValues(key: null, value: value, containValue: containValue, listBehavior: listBehavior);
    return true;
  } catch (e) {
    return false;
  }
}
