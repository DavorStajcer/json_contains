/// Defines the behavior when comparing if a JSON list contains another JSON list.
///
/// By default:
/// - order of items in the list does not matter
/// - the length of the list does not matter
class JsonContainsListBehavior {
  final bool compareOrder;
  final bool compareLenght;

  const JsonContainsListBehavior({
    this.compareOrder = false,
    this.compareLenght = false,
  });
}
