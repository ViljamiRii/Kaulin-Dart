/// This file defines the core token types and the Token class
/// used in the Kaulin Dart language. Tokens are the basic lexical
/// building blocks of the language and are used during parsing.

/// Enum representing all possible token types in Kaulin Dart.
enum TokenType {
  // Single-character tokens
  leftParen, // (
  rightParen, // )
  leftBrace, // {
  rightBrace, // }
  leftBracket, // [
  rightBracket, // ]
  comma, // ,
  dot, // .
  semicolon, // ;
  minus, // -
  plus, // +
  slash, // /
  star, // *
  modulus, // %
  // Comparison operators
  equal, // =
  equalEqual, // ==
  bangEqual, // !=
  less, // <
  lessEqual, // <=
  greater, // >
  greaterEqual, // >=
  // Literals
  identifier, // variable/function names
  string, // string literals
  number, // numeric literals
  // Keywords and types
  for_,
  while_,
  if_,
  else_,
  return_, // control flow
  func,
  var_, // declarations
  true_,
  false_,
  null_, // literals
  integer,
  float,
  stringType,
  boolean, // type keywords
  array,
  tuple, // data structure keywords
  // Logical operators
  or,
  and, // |, &
  // End-of-file
  eof,
}

/// Class representing a single token with its type,
/// the exact source text (lexeme), optional literal value,
/// and the line number where it was found.
class Token {
  /// Type of the token (from TokenType).
  final TokenType type;

  /// Raw string (lexeme) from the source code.
  final String lexeme;

  /// Optional literal value (parsed number or string).
  final Object? literal;

  /// Line number in source code for this token.
  final int line;

  /// Constructs a new Token instance.
  Token(this.type, this.lexeme, this.literal, this.line);

  /// Returns a human-readable string representation of this token.
  @override
  String toString() {
    return '\$type \$lexeme \$literal';
  }
}
