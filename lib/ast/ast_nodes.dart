/// Abstract Syntax Tree (AST) nodes for Kaulin Dart.
/// This file defines the structure of all expressions and statements used in the interpreter.

/// The base class for all statements.
abstract class Stmt {}

/// A variable declaration: `muuttuja nimi = arvo;`
class VarDeclarationStmt extends Stmt {
  /// The variable name.
  final String name;

  /// The initializer expression.
  final Expr initializer;

  /// Optional declared type (e.g., "int", "str").
  final String? declaredType;

  VarDeclarationStmt(this.name, this.initializer, [this.declaredType]);

  @override
  String toString() =>
      declaredType != null
          ? 'Muuttuja($declaredType $name = $initializer)'
          : 'Muuttuja($name = $initializer)';
}

/// A statement that wraps a single expression.
class ExpressionStmt extends Stmt {
  final Expr expression;

  ExpressionStmt(this.expression);

  @override
  String toString() => 'Lauseke($expression)';
}

/// A block of statements enclosed in `{}`.
class BlockStmt extends Stmt {
  final List<Stmt> statements;

  BlockStmt(this.statements);

  @override
  String toString() => 'Lohko(${statements.join('; ')})';
}

/// An if-else conditional statement.
class IfStmt extends Stmt {
  final Expr condition;
  final Stmt thenBranch;
  final Stmt? elseBranch;

  IfStmt(this.condition, this.thenBranch, [this.elseBranch]);

  @override
  String toString() => 'Jos($condition ? $thenBranch : $elseBranch)';
}

/// A while loop.
class WhileStmt extends Stmt {
  final Expr condition;
  final Stmt body;

  WhileStmt(this.condition, this.body);

  @override
  String toString() => 'Kun($condition) { $body }';
}

/// A function declaration: `funktio nimi(parametrit) { ... }`
class FunctionStmt extends Stmt {
  final String name;
  final List<String> parameters;
  final BlockStmt body;

  FunctionStmt(this.name, this.parameters, this.body);

  @override
  String toString() => 'Funktio($name(${parameters.join(', ')}) $body)';
}

/// A return statement: `paluu arvo;`
class ReturnStmt extends Stmt {
  final Expr value;

  ReturnStmt(this.value);

  @override
  String toString() => 'Paluu($value)';
}

/// The base class for all expressions.
abstract class Expr {}

/// Enum representing supported literal types.
enum LiteralType { integer, float, string, boolean, null_ }

/// A literal value such as a number, string, boolean, or null.
class LiteralExpr extends Expr {
  final Object? value;
  final LiteralType type;

  LiteralExpr(this.value, this.type);

  @override
  String toString() => 'Literaali($value : $type)';
}

/// A reference to a variable by name.
class IdentifierExpr extends Expr {
  final String name;

  IdentifierExpr(this.name);

  @override
  String toString() => 'Tunniste($name)';
}

/// An assignment expression: `nimi = arvo`
class AssignmentExpr extends Expr {
  final String name;
  final Expr value;

  AssignmentExpr(this.name, this.value);

  @override
  String toString() => 'Aseta($name = $value)';
}

/// A binary operation: `vasen + oikea`, `x == y`, etc.
class BinaryExpr extends Expr {
  final Expr left;
  final String operator;
  final Expr right;

  BinaryExpr(this.left, this.operator, this.right);

  @override
  String toString() => 'Binaari($left $operator $right)';
}

/// A function call: `nimi(parametrit)`
class CallExpr extends Expr {
  final Expr callee;
  final List<Expr> arguments;

  CallExpr(this.callee, this.arguments);

  @override
  String toString() => 'Kutsu($callee, parametrit: $arguments)';
}

/// An array literal: `[1, 2, 3]`
class ArrayExpr extends Expr {
  final List<Expr> elements;

  ArrayExpr(this.elements);

  @override
  String toString() => 'Joukko($elements)';
}

/// A tuple literal: `(1, "hello")`
class TupleExpr extends Expr {
  final List<Expr> elements;

  TupleExpr(this.elements);

  @override
  String toString() => 'Monikko($elements)';
}
