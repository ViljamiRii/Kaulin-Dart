import 'package:test/test.dart';
import 'package:kaulin_dart/parser/lexer.dart';
import 'package:kaulin_dart/parser/parser.dart';
import 'package:kaulin_dart/interpreter/eval.dart';

void main() {
  group('KaulinInterpreter Function Evaluation', () {
    test('Evaluates modulo with integers', () {
      final code = """
        muuttuja x = 10 % 3;
        x;
      """;
      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (final stmt in stmts) {
        interpreter.execute(stmt);
      }
      expect(interpreter.getLastValue(), equals(1));
    });

    test('Evaluates modulo with zero remainder', () {
      final code = """
        muuttuja x = 12 % 4;
        x;
      """;
      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (final stmt in stmts) {
        interpreter.execute(stmt);
      }
      expect(interpreter.getLastValue(), equals(0));
    });

    test('Evaluates a simple tuple', () {
      final code = """
        muuttuja t = (1, 2);
        t;
      """;
      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }
      expect(interpreter.getLastValue(), equals(KaulinTuple([1, 2])));
    });

    test('Evaluates a nested tuple', () {
      final code = """
        muuttuja t = (1, (2, 3));
        t;
      """;
      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }
      expect(
        interpreter.getLastValue(),
        equals(
          KaulinTuple([
            1,
            KaulinTuple([2, 3]),
          ]),
        ),
      );
    });

    test('Defines and calls a simple function', () {
      final code = """
        funktio kerro(x) { paluu x * 2; }
        muuttuja y = kerro(5);
        y;
      """;

      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }

      expect(interpreter.getLastValue(), equals(10));
    });

    test('Function with multiple parameters', () {
      final code = """
        funktio summa(a, b) { paluu a + b; }
        muuttuja x = summa(3, 4);
        x;
      """;

      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }

      expect(interpreter.getLastValue(), equals(7));
    });

    test('Function returns a constant', () {
      final code = """
        funktio vakio() { paluu 42; }
        muuttuja x = vakio();
        x;
      """;

      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }

      expect(interpreter.getLastValue(), equals(42));
    });

    test('Nested function call', () {
      final code = """
        funktio tuplaa(x) { paluu x * 2; }
        funktio nosta(x) { paluu tuplaa(x) + 1; }
        muuttuja x = nosta(3);
        x;
      """;

      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }

      expect(interpreter.getLastValue(), equals(7));
    });

    test('Evaluates a simple array', () {
      final code = """
        muuttuja a = [1, 2, 3];
        a;
      """;
      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }
      expect(interpreter.getLastValue(), equals([1, 2, 3]));
    });

    test('Evaluates a nested array', () {
      final code = """
        muuttuja a = [1, [2, 3]];
        a;
      """;
      final parser = Parser(Lexer(code).scanTokens());
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();
      for (var stmt in stmts) {
        interpreter.execute(stmt);
      }
      expect(
        interpreter.getLastValue(),
        equals([
          1,
          [2, 3],
        ]),
      );
    });
  });
}
