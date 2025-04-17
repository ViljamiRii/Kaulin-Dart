/// Kaulin Dart Language Entry Point
/// This file starts a REPL (Read-Eval-Print Loop) for interactive parsing.
/// If a filename is provided as an argument, it executes the file.
/// Otherwise, it enters an interactive loop (REPL).

import 'dart:io';
import 'package:kaulin_dart/parser/lexer.dart';
import 'package:kaulin_dart/parser/parser.dart';
import 'package:kaulin_dart/interpreter/eval.dart';

/// The main function initializes the REPL or runs a `.dka` file if provided.
void main(List<String> args) {
  if (args.isNotEmpty) {
    final filename = args[0];
    final source = File(filename).readAsStringSync();

    final lexer = Lexer(source);
    final tokens = lexer.scanTokens();

    final parser = Parser(tokens);
    final stmts = parser.parse();

    final interpreter = KaulinInterpreter();
    for (final stmt in stmts) {
      interpreter.execute(stmt);
    }

    return;
  }

  // Fallback to REPL mode
  print('Tervetuloa Kaulin Dart REPL:n');
  print(
    'Kirjoita ilmaisu ja paina Enter-näppäintä. Kirjoita "poistu" lopettaaksesi.\n',
  );

  final interpreter = KaulinInterpreter();

  while (true) {
    stdout.write('> ');
    final input = stdin.readLineSync();

    if (input == null || input.trim().toLowerCase() == 'poistu') {
      print('Heipä hei!');
      break;
    }

    try {
      final lexer = Lexer(input);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens);
      final stmts = parser.parse();

      for (final stmt in stmts) {
        interpreter.execute(stmt);
        final result = interpreter.getLastValue();
        if (result != null) {
          print('=> $result');
        }
      }
    } catch (e) {
      print('Virhe: $e');
    }
  }
}
