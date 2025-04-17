import '../ast/ast_nodes.dart';
import '../core/builtins.dart';
import 'environment.dart';

/// Exception used to signal a return from a function.
class ReturnException implements Exception {
  final Object? value;
  ReturnException(this.value);
}

/// Represents a callable function in Kaulin Dart.
class KaulinFunction {
  /// The original function declaration (AST).
  final FunctionStmt declaration;

  /// The environment where the function was declared (for closures).
  final Environment closure;

  KaulinFunction(this.declaration, this.closure);

  /// Calls the function with a list of argument values.
  Object? call(List<Object?> args) {
    final environment = Environment.enclosed(closure);
    for (int i = 0; i < declaration.parameters.length; i++) {
      environment.define(declaration.parameters[i], args[i]);
    }

    try {
      for (final stmt in declaration.body.statements) {
        KaulinInterpreter(environment).execute(stmt);
      }
    } on ReturnException catch (e) {
      return e.value;
    }

    return null;
  }

  @override
  String toString() => "<funktio ${declaration.name}>";
}

/// Main interpreter for Kaulin Dart.
/// Evaluates expressions and executes statements using an environment.
class KaulinInterpreter {
  /// Global or inherited environment (scope).
  final Environment _globals;

  /// The last evaluated value.
  Object? lastValue;

  KaulinInterpreter([Environment? globals])
    : _globals = globals ?? Environment() {
    // Load built-in functions into the global scope
    for (final entry in builtInFunctions.entries) {
      _globals.define(entry.key, entry.value);
    }
  }

  /// Evaluates an expression and returns its result.
  Object? evaluate(Expr expr) {
    if (expr is ArrayExpr) {
      return expr.elements.map(evaluate).toList();
    }
    if (expr is TupleExpr) {
      return KaulinTuple(expr.elements.map(evaluate).toList());
    }
    if (expr is LiteralExpr) return expr.value;
    if (expr is IdentifierExpr) return _globals.get(expr.name);
    if (expr is AssignmentExpr) {
      final value = evaluate(expr.value);
      _globals.assign(expr.name, value);
      return value;
    }
    if (expr is BinaryExpr) {
      final left = evaluate(expr.left);
      final right = evaluate(expr.right);

      switch (expr.operator) {
        case '+':
          if (left is String || right is String) {
            return left.toString() + right.toString();
          }
          if (left is num && right is num) {
            return left + right;
          }
          throw Exception("Virheellinen '+' operaatio: $left ja $right");
        case '-':
          return (left as num) - (right as num);
        case '*':
          return (left as num) * (right as num);
        case '%':
          if (left is num && right is num) {
            return left % right;
          }
          throw Exception("Virheellinen '%' operaatio: $left ja $right");
        case '/':
          return (left as num) / (right as num);
        case '==':
          return left == right;
        case '!=':
          return left != right;
        case '<':
          return (left as num) < (right as num);
        case '<=':
          return (left as num) <= (right as num);
        case '>':
          return (left as num) > (right as num);
        case '>=':
          return (left as num) >= (right as num);
        default:
          throw Exception("Unsupported operator '${expr.operator}'");
      }
    }
    if (expr is CallExpr) {
      final callee = evaluate(expr.callee);
      final args = expr.arguments.map(evaluate).toList();

      if (callee is KaulinFunction) {
        return callee.call(args);
      }
      if (callee is Function) {
        return Function.apply(callee, [args]);
      }

      throw Exception("Can only call functions.");
    }

    throw Exception('Unsupported expression: $expr');
  }

  /// Executes a statement (AST node).
  void execute(Stmt stmt) {
    if (stmt is ExpressionStmt) {
      final value = evaluate(stmt.expression);
      lastValue = value;
    } else if (stmt is VarDeclarationStmt) {
      final value = evaluate(stmt.initializer);

      if (stmt.declaredType != null) {
        final expected = stmt.declaredType!;
        final actual = value.runtimeType;

        final typeMap = {
          'int': int,
          'liukuluku': double,
          'str': String,
          'bool': bool,
          'monikko': KaulinTuple,
          'joukko': List,
        };

        if (!typeMap.containsKey(expected)) {
          throw Exception("Unknown type '$expected'");
        }

        final expectedType = typeMap[expected];

        if (expectedType != null && value.runtimeType != expectedType) {
          throw Exception(
            "Type mismatch: Expected '$expected', but got '${actual.runtimeType}'",
          );
        }
      }

      _globals.define(stmt.name, value);
    } else if (stmt is BlockStmt) {
      executeBlock(stmt.statements);
    } else if (stmt is IfStmt) {
      final condition = evaluate(stmt.condition);
      if (condition == true) {
        execute(stmt.thenBranch);
      } else if (stmt.elseBranch != null) {
        execute(stmt.elseBranch!);
      }
    } else if (stmt is WhileStmt) {
      while (evaluate(stmt.condition) == true) {
        execute(stmt.body);
      }
    } else if (stmt is FunctionStmt) {
      final funktio = KaulinFunction(stmt, _globals);
      _globals.define(stmt.name, funktio);
    } else if (stmt is ReturnStmt) {
      final value = evaluate(stmt.value);
      throw ReturnException(value);
    } else {
      throw Exception('Unsupported statement: $stmt');
    }
  }

  /// Executes a list of statements as a block (currently flat scope).
  void executeBlock(List<Stmt> statements) {
    for (final stmt in statements) {
      execute(stmt);
    }
  }

  /// Returns the last value evaluated by the interpreter.
  Object? getLastValue() => lastValue;
}

/// Represents a fixed-size ordered collection of values.
class KaulinTuple {
  final List<Object?> values;

  KaulinTuple(this.values);

  @override
  String toString() {
    if (values.length == 1) {
      return '(${values.first},)';
    }
    return '(${values.join(', ')})';
  }

  @override
  bool operator ==(Object other) =>
      other is KaulinTuple && _listEquals(values, other.values);

  @override
  int get hashCode => values.hashCode;

  bool _listEquals(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
