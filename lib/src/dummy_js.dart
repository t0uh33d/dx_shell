class JsObject {
  void callMethod(Object method, [List<dynamic>? args]) {}

  dynamic operator [](Object property) {}
}

final context = JsObject();
