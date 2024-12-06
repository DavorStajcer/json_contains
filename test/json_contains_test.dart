import 'package:json_contains/json_contains.dart';
import 'package:test/test.dart';

void main() {
  group('jsonContains', () {
    test('Default behaviour: returns true when lists have same elements in different order', () {
      final json = {
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

      final jsonToContain = {
        "skills": ["React", "Dart"],
        "projects": [
          {
            "tags": ["popular", "open-source"]
          }
        ]
      };

      expect(jsonContains(json: json, jsonToContain: jsonToContain), isTrue);
    });

    test('Default behaviour: returns true when jsonToContain has fewer list elements', () {
      final json = {
        "skills": ["Dart", "Flutter", "React", "Python"],
      };

      final jsonToContain = {
        "skills": ["Flutter", "Dart"]
      };

      expect(jsonContains(json: json, jsonToContain: jsonToContain), isTrue);
    });

    test('Default behaviour: returns false when list elements are missing', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Dart", "JavaScript"]
      };

      expect(jsonContains(json: json, jsonToContain: jsonToContain), isFalse);
    });
  });

  group('When compareOrder is set to true', () {
    test('compareOrder: true: returns true when list elements are in the same order', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Dart", "Flutter"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isTrue,
      );
    });

    test('compareOrder: true: returns false when list elements are in a different order', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Flutter", "Dart"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isFalse,
      );
    });
  });

  group('When compareLenght is set to true', () {
    test('compareOrder: true: returns true when list elements are in the same order', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Dart", "Flutter"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isTrue,
      );
    });

    test('compareOrder: true: returns false when list elements are in a different order', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Flutter", "Dart"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isFalse,
      );
    });
  });

  group('When both compareOrder and compareLenght is set to true', () {
    test('compareOrder: true and compareLenght: true: returns true when both order and length match', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Dart", "Flutter", "React"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true, compareLenght: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isTrue,
      );
    });

    test('compareOrder: true and compareLenght: true: returns false when order does not match', () {
      final json = {
        "skills": ["Dart", "React", "Flutter"],
      };

      final jsonToContain = {
        "skills": ["Dart", "Flutter", "React"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true, compareLenght: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isFalse,
      );
    });

    test('compareOrder: true and compareLenght: true: returns false when length does not match', () {
      final json = {
        "skills": ["Dart", "Flutter", "React"],
      };

      final jsonToContain = {
        "skills": ["Dart", "Flutter"]
      };

      final listBehaviour = JsonContainsListBehavior(compareOrder: true, compareLenght: true);

      expect(
        jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
        isFalse,
      );
    });
  });

  group('jsonContains with deeply nested JSON objects', () {
    group('Default behaviour (ignores order and length)', () {
      test('returns true when lists of JSON objects contain other lists with JSON objects in any order', () {
        final json = {
          "company": {
            "departments": [
              {
                "name": "Engineering",
                "teams": [
                  {
                    "teamName": "Backend",
                    "members": [
                      {"name": "Alice", "role": "developer"},
                      {"name": "Bob", "role": "architect"}
                    ]
                  },
                  {
                    "teamName": "Frontend",
                    "members": [
                      {"name": "Eve", "role": "developer"},
                      {"name": "Frank", "role": "tester"}
                    ]
                  }
                ]
              },
              {
                "name": "Design",
                "teams": [
                  {
                    "teamName": "UI/UX",
                    "members": [
                      {"name": "Grace", "role": "designer"},
                      {"name": "Hank", "role": "researcher"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "company": {
            "departments": [
              {
                "teams": [
                  {
                    "members": [
                      {"name": "Alice", "role": "developer"}
                    ]
                  },
                  {"teamName": "Frontend"}
                ]
              }
            ]
          }
        };

        expect(jsonContains(json: json, jsonToContain: jsonToContain), isTrue);
      });

      test('returns false when nested list items do not match', () {
        final json = {
          "company": {
            "departments": [
              {
                "name": "Engineering",
                "teams": [
                  {
                    "teamName": "Backend",
                    "members": [
                      {"name": "Alice", "role": "developer"},
                      {"name": "Bob", "role": "architect"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "company": {
            "departments": [
              {
                "teams": [
                  {
                    "members": [
                      {"name": "Charlie", "role": "developer"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        expect(jsonContains(json: json, jsonToContain: jsonToContain), isFalse);
      });
    });

    group('With compareOrder: true', () {
      test('returns true when nested list order matches exactly', () {
        final json = {
          "project": {
            "phases": [
              {
                "name": "Phase 1",
                "tasks": [
                  {
                    "taskName": "Setup",
                    "subtasks": [
                      {"name": "Install dependencies", "status": "complete"},
                      {"name": "Configure CI/CD", "status": "in-progress"}
                    ]
                  },
                  {
                    "taskName": "Development",
                    "subtasks": [
                      {"name": "Implement feature A", "status": "pending"},
                      {"name": "Code review", "status": "pending"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "project": {
            "phases": [
              {
                "tasks": [
                  {
                    "taskName": "Setup",
                    "subtasks": [
                      {"name": "Install dependencies", "status": "complete"},
                      {"name": "Configure CI/CD", "status": "in-progress"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final listBehaviour = JsonContainsListBehavior(compareOrder: true);

        expect(
          jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
          isTrue,
        );
      });

      test('returns false when nested list order does not match', () {
        final json = {
          "project": {
            "phases": [
              {
                "name": "Phase 1",
                "tasks": [
                  {
                    "taskName": "Setup",
                    "subtasks": [
                      {"name": "Install dependencies", "status": "complete"},
                      {"name": "Configure CI/CD", "status": "in-progress"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "project": {
            "phases": [
              {
                "tasks": [
                  {
                    "subtasks": [
                      {"name": "Configure CI/CD", "status": "in-progress"},
                      {"name": "Install dependencies", "status": "complete"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final listBehaviour = JsonContainsListBehavior(compareOrder: true);

        expect(
          jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
          isFalse,
        );
      });
    });

    group('With compareLenght: true', () {
      test('returns false when nested lists differ in length', () {
        final json = {
          "company": {
            "departments": [
              {
                "name": "Engineering",
                "teams": [
                  {
                    "teamName": "Backend",
                    "members": [
                      {"name": "Alice", "role": "developer"},
                      {"name": "Bob", "role": "architect"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "company": {
            "departments": [
              {
                "teams": [
                  {
                    "members": [
                      {"name": "Alice", "role": "developer"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final listBehaviour = JsonContainsListBehavior(compareLenght: true);

        expect(
          jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
          isFalse,
        );
      });
    });

    group('With compareOrder: true and compareLenght: true', () {
      test('returns true when both order and length match in deeply nested lists', () {
        final json = {
          "organization": {
            "departments": [
              {
                "name": "IT",
                "teams": [
                  {
                    "teamName": "Infrastructure",
                    "projects": [
                      {"name": "Cloud Migration", "status": "complete"},
                      {"name": "Security Enhancement", "status": "in-progress"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "organization": {
            "departments": [
              {
                "teams": [
                  {
                    "projects": [
                      {"name": "Cloud Migration", "status": "complete"},
                      {"name": "Security Enhancement", "status": "in-progress"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final listBehaviour = JsonContainsListBehavior(compareOrder: true, compareLenght: true);

        expect(
          jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
          isTrue,
        );
      });

      test('returns false when order matches but length does not', () {
        final json = {
          "organization": {
            "departments": [
              {
                "teams": [
                  {
                    "projects": [
                      {"name": "Cloud Migration", "status": "complete"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final jsonToContain = {
          "organization": {
            "departments": [
              {
                "teams": [
                  {
                    "projects": [
                      {"name": "Cloud Migration", "status": "complete"},
                      {"name": "Security Enhancement", "status": "in-progress"}
                    ]
                  }
                ]
              }
            ]
          }
        };

        final listBehaviour = JsonContainsListBehavior(compareOrder: true, compareLenght: true);

        expect(
          jsonContains(json: json, jsonToContain: jsonToContain, listBehavior: listBehaviour),
          isFalse,
        );
      });
    });
  });
}
