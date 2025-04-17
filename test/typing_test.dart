import 'package:test/test.dart';
import 'package:kaulin_dart/parser/lexer.dart';
import 'package:kaulin_dart/parser/parser.dart';
import 'package:kaulin_dart/interpreter/eval.dart';

void main() {
  group('Type Checking Tests', () {
    test('Accepts correct int declaration', () {
      final code = "int x = 5;";
      final parser = Parser(Lexer(code).scanTokens());
      
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();

      expect(() => interpreter.execute(stmts.first), returnsNormally);
    });

    test('Rejects incorrect int declaration', () {
      final code = "int x = \"hello\";";
      final parser = Parser(Lexer(code).scanTokens());
      
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();

      expect(() => interpreter.execute(stmts.first), throwsA(isA<Exception>()));
    });

    test('Accepts correct str declaration', () {
      final code = "str s = \"hi\";";
      final parser = Parser(Lexer(code).scanTokens());
      
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();

      expect(() => interpreter.execute(stmts.first), returnsNormally);
    });

    test('Rejects float assigned to int', () {
      final code = "int x = 3.14;";
      final parser = Parser(Lexer(code).scanTokens());
      
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();

      expect(() => interpreter.execute(stmts.first), throwsA(isA<Exception>()));
    });

    test('Accepts tuple declaration', () {
      final code = "monikko t = (1, 2);";
      final parser = Parser(Lexer(code).scanTokens());
      
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();

      expect(() => interpreter.execute(stmts.first), returnsNormally);
    });

    test('Rejects tuple with wrong declared type', () {
      final code = "str t = (1, 2);";
      final parser = Parser(Lexer(code).scanTokens());
      
      final interpreter = KaulinInterpreter();
      final stmts = parser.parse();

      expect(() => interpreter.execute(stmts.first), throwsA(isA<Exception>()));
    });
  });
}
