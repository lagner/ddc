

class Tag<T> {
  final String id;
  final bool singleton;

  Type get interface => T;

  const Tag({this.id = '', this.singleton = false});

  @override
  String toString() {
    final name = id.isEmpty 
      ? "${T.toString()}" 
      : "${T.toString()} - ${id}";

    return "Tag(${name})";
  }
}
