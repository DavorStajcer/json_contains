## Table of Contents
- [About](#-about)
- [List behavior](#-list-behavior)
- [My real usecase](#-usage)

##  🚀 About

**JSON Contains** is implemented in order to check if one JSON objects is contained in another. In the example below the 
comparison will be true.

```dart
final firstJson = {
    "name": "John",
    "age": 30,
    "address": {"street": "Main Street", "city": "New York"}
};

final secondJson = {
    "name": "John",
    "address": {"city": "New York"}
};

final result = jsonContains(json: firstJson, jsonToContain: secondJson);
print(result); // true

```


## [..] Lsit behavior

By default when two lists are compared:
- lenght of the lists is not compared
- ordering of items is not compared

For example, the following will be true:

```dart
  final firstJson = {
    "skills": ["Dart", "Flutter", "React", "Python"],
  };

  final secondJson = {
    "skills": ["Flutter", "Dart"]
  };

  final result = jsonContains(json: firstJson, jsonToContain: secondJson);
  print(result); // true
```

```dart
  final firstJson = {
    "name": "John",
    "skills": ["Dart", "Flutter", "React"],
    "projects": [
      {
        "title": "Project A",
        "tags": ["open-source", "popular"]
      },
      {
        "title": "Project B",
        "tags": ["internal"]
      }
    ]
  };

  final secondJson = {
    "skills": ["React", "Dart"],
    "projects": [
      {
        "tags": ["popular", "open-source"]
      }
    ]
  };
  final result = jsonContains(json: firstJson, jsonToContain: secondJson);
  print(result); // true
```

## My real usecase

I needed this in an IoT project, here was my usecase:
- mobile app is connected to a socket
- IoT device is connected to a socket
- mobile app sends a "desired state chage" update to the socket
- IoT device picks up that change
- IoT device sends the "change in its current state" to the socket all the time
- In order for the app to "know" the IoT device is has changed to the desired state it needs to check if the 
JSON object reported by the device contains its "desired state change" JSON object