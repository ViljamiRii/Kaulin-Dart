import 'package:test/test.dart';
import 'package:kaulin_dart/parser/lexer.dart';
import 'package:kaulin_dart/parser/parser.dart';
import 'package:kaulin_dart/ast/ast_nodes.dart';

void main() {
  /// Utility to simplify repetitive parsing + assertion
  void expectParsed(String source, Type expectedType, {int index = 0}) {
    final parser = Parser(Lexer(source).scanTokens());
    final result = parser.parse();
    expect(result[index], isA<Stmt>());
    expect(result[index].runtimeType, equals(expectedType));
  }

  group('Parser Tests', () {
    // Built-in function calls
    test('Call to tulosta', () {
      expectParsed('tulosta("Hei");', ExpressionStmt);
    });

    test('Call to syöte with prompt', () {
      expectParsed('muuttuja nimi = syöte("Nimi? ");', VarDeclarationStmt);
    });

    test('Call to aika with no arguments', () {
      expectParsed('muuttuja aikahetki = aika();', VarDeclarationStmt);
    });

    // Original core tests
    test('Tuple literal: simple', () {
      expectParsed("muuttuja t = (1, 2);", VarDeclarationStmt);
    });

    test('Tuple literal: nested', () {
      expectParsed("muuttuja t = (1, (2, 3));", VarDeclarationStmt);
    });

    test('Array literal: simple', () {
      expectParsed("muuttuja a = [1, 2, 3];", VarDeclarationStmt);
    });

    test('Array literal: empty', () {
      expectParsed("muuttuja a = [];", VarDeclarationStmt);
    });

    test('Expression: simple', () {
      expectParsed("42;", ExpressionStmt);
    });

    test('Expression: complex', () {
      expectParsed("(1 + 2) * 3;", ExpressionStmt);
    });

    test('Assignment Expression: simple', () {
      expectParsed("x = 10;", ExpressionStmt);
    });

    test('Assignment Expression: complex', () {
      expectParsed("x = (a + b) * 2;", ExpressionStmt);
    });

    test('Var Declaration: simple', () {
      expectParsed("muuttuja x = 1;", VarDeclarationStmt);
    });

    test('Var Declaration: complex', () {
      expectParsed("muuttuja total = (a + b) * c;", VarDeclarationStmt);
    });

    test('If Statement: simple', () {
      expectParsed("jos (tosi) x = 1;", IfStmt);
    });

    test('If Statement: complex', () {
      expectParsed("jos (x > 10) muuttuja y = 5; toisin y = 0;", IfStmt);
    });

    test('While Statement: simple', () {
      expectParsed("kun (x < 5) x = x + 1;", WhileStmt);
    });

    test('While Statement: complex', () {
      expectParsed(
        "kun (count != 0) { count = count - 1; total = total + 1; }",
        WhileStmt,
      );
    });

    test('For Statement: simple', () {
      expectParsed(
        "toista (muuttuja i = 0; i < 10; i = i + 1) print(i);",
        BlockStmt,
      );
    });

    test('For Statement: complex', () {
      expectParsed(
        "toista (muuttuja j = 1; j <= 3; j = j + 1) { sum = sum + j; log(j); }",
        BlockStmt,
      );
    });

    test('Block Statement: simple', () {
      expectParsed("{ muuttuja a = 1; }", BlockStmt);
    });

    test('Block Statement: complex', () {
      expectParsed(
        "{ muuttuja x = 10; muuttuja y = x + 20; z = y * 2; }",
        BlockStmt,
      );
    });

    test('Function Declaration: single parameter', () {
      expectParsed("funktio tuplaa(x) { paluu x * 2; }", FunctionStmt);
    });

    test('Function Declaration: multiple parameters', () {
      expectParsed("funktio summa(a, b) { paluu a + b; }", FunctionStmt);
    });

    test('Return Statement: constant', () {
      expectParsed("paluu 42;", ReturnStmt);
    });

    test('Return Statement: expression', () {
      expectParsed("paluu 1 + 2 * 3;", ReturnStmt);
    });
  });
}
