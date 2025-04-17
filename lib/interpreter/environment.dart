/// Defines the environment model for variable scopes in Kaulin Dart.
/// Supports nested scopes and variable resolution with lexical scoping.

class Environment {
  /// Holds variable bindings in the current scope.
  final Map<String, Object?> _values = {};

  /// Optional reference to the enclosing (parent) environment.
  final Environment? _enclosing;

  /// Creates a new environment, optionally enclosed within another.
  Environment([this._enclosing]);

  /// Factory constructor to create a nested environment.
  factory Environment.enclosed(Environment parent) {
    return Environment(parent);
  }

  /// Defines a new variable in the current environment.
  /// If the variable already exists in this scope, it is overwritten.
  void define(String name, Object? value) {
    _values[name] = value;
  }

  /// Retrieves the value of a variable, searching outward through enclosing scopes.
  /// Throws an exception if the variable is not found.
  Object? get(String name) {
    if (_values.containsKey(name)) return _values[name];
    if (_enclosing != null) return _enclosing.get(name);
    throw Exception("Undefined variable '$name'.");
  }

  /// Assigns a new value to an existing variable.
  /// Searches enclosing environments if the variable is not in the current scope.
  /// Throws an exception if the variable is not declared.
  void assign(String name, Object? value) {
    if (_values.containsKey(name)) {
      _values[name] = value;
      return;
    }
    if (_enclosing != null) {
      _enclosing.assign(name, value);
      return;
    }
    throw Exception("Cannot assign to undeclared variable '$name'.");
  }

  @override
  String toString() => _values.toString();
}
