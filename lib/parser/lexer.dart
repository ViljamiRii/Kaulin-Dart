/// The Kaulin Dart lexer converts source code into a stream of tokens
/// based on the token types defined in `token.dart`.
/// Handles identifiers, keywords, literals, punctuation, and operators.

import 'token.dart';

/// The Lexer class performs lexical analysis (tokenization).
class Lexer {
  /// Full source code input.
  final String source;

  /// List of generated tokens.
  final List<Token> tokens = [];

  int _start = 0;
  int _current = 0;
  int _line = 1;

  /// Reserved keywords mapped to their token types.
  static final Map<String, TokenType> _keywords = {
    'toista': TokenType.for_,
    'kun': TokenType.while_,
    'jos': TokenType.if_,
    'toisin': TokenType.else_,
    'paluu': TokenType.return_,
    'funktio': TokenType.func,
    'muuttuja': TokenType.var_,
    'tosi': TokenType.true_,
    'epätosi': TokenType.false_,
    'tyhjä': TokenType.null_,
    'int': TokenType.integer,
    'str': TokenType.stringType,
    'bool': TokenType.boolean,
    'joukko': TokenType.array,
    'monikko': TokenType.tuple,
    'liukuluku': TokenType.float,
  };

  /// Constructs a Lexer from the given source code.
  Lexer(this.source);

  /// Scans the full input and returns a list of tokens.
  List<Token> scanTokens() {
    while (!_isAtEnd()) {
      _start = _current;
      _scanToken();
    }

    tokens.add(Token(TokenType.eof, "", null, _line));
    return tokens;
  }

  /// Scans and classifies a single token.
  void _scanToken() {
    final c = _advance();
    switch (c) {
      case '(':
        _addToken(TokenType.leftParen);
        break;
      case ')':
        _addToken(TokenType.rightParen);
        break;
      case '{':
        _addToken(TokenType.leftBrace);
        break;
      case '}':
        _addToken(TokenType.rightBrace);
        break;
      case '[':
        _addToken(TokenType.leftBracket);
        break;
      case ']':
        _addToken(TokenType.rightBracket);
        break;
      case ',':
        _addToken(TokenType.comma);
        break;
      case '.':
        _addToken(TokenType.dot);
        break;
      case ';':
        _addToken(TokenType.semicolon);
        break;
      case '+':
        _addToken(TokenType.plus);
        break;
      case '-':
        _addToken(TokenType.minus);
        break;
      case '*':
        _addToken(TokenType.star);
        break;
      case '/':
        _addToken(TokenType.slash);
        break;
      case '%':
        _addToken(TokenType.modulus);
        break;
      case '|':
        _addToken(TokenType.or);
        break;
      case '&':
        _addToken(TokenType.and);
        break;
      case '!':
        _addToken(_match('=') ? TokenType.bangEqual : null);
        break;
      case '=':
        _addToken(_match('=') ? TokenType.equalEqual : TokenType.equal);
        break;
      case '<':
        _addToken(_match('=') ? TokenType.lessEqual : TokenType.less);
        break;
      case '>':
        _addToken(_match('=') ? TokenType.greaterEqual : TokenType.greater);
        break;

      case ' ':
      case '\r':
      case '\t':
        break; // ignore whitespace
      case '\n':
        _line++;
        break; // newline tracking

      case '"':
        _string();
        break;

      default:
        if (_isDigit(c)) {
          _number();
        } else if (_isAlpha(c)) {
          _identifier();
        } else {
          // Unrecognized character; could throw or skip
        }
        break;
    }
  }

  /// Consumes the next character and returns it.
  String _advance() => source[_current++];

  /// Checks if we've reached the end of input.
  bool _isAtEnd() => _current >= source.length;

  /// Adds a token with optional literal value.
  void _addToken(TokenType? type, [Object? literal]) {
    if (type != null) {
      final text = source.substring(_start, _current);
      tokens.add(Token(type, text, literal, _line));
    }
  }

  /// Conditionally consumes the next character if it matches [expected].
  bool _match(String expected) {
    if (_isAtEnd()) return false;
    if (source[_current] != expected) return false;
    _current++;
    return true;
  }

  /// Parses a string literal enclosed in double quotes.
  void _string() {
    while (!_isAtEnd() && source[_current] != '"') {
      if (source[_current] == '\n') _line++;
      _current++;
    }

    if (_isAtEnd()) return; // Unterminated string

    _current++; // Consume closing quote
    final value = source.substring(_start + 1, _current - 1);
    _addToken(TokenType.string, value);
  }

  /// Parses integer and floating-point number literals.
  void _number() {
    while (_isDigit(_peek())) _advance();

    if (_peek() == '.' && _isDigit(_peekNext())) {
      _advance(); // Consume the '.'
      while (_isDigit(_peek())) _advance();
      _addToken(
        TokenType.float,
        double.parse(source.substring(_start, _current)),
      );
    } else {
      _addToken(
        TokenType.number,
        int.parse(source.substring(_start, _current)),
      );
    }
  }

  /// Parses identifiers and checks for reserved keywords.
  void _identifier() {
    while (_isAlphaNumeric(_peek())) _advance();

    final text = source.substring(_start, _current);
    final type = _keywords[text] ?? TokenType.identifier;
    _addToken(type);
  }

  /// Returns the current unconsumed character.
  String _peek() => _isAtEnd() ? '\u0000' : source[_current];

  /// Returns the character after the current one.
  String _peekNext() =>
      (_current + 1 >= source.length) ? '\u0000' : source[_current + 1];

  /// Checks if the character is a digit (0–9).
  bool _isDigit(String c) =>
      c.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
      c.codeUnitAt(0) <= '9'.codeUnitAt(0);

  /// Checks if the character is a letter or underscore.
  bool _isAlpha(String c) =>
      RegExp(r'\p{L}|\p{N}|_', unicode: true).hasMatch(c);

  /// Checks if the character is a letter, underscore, or digit.
  bool _isAlphaNumeric(String c) => _isAlpha(c) || _isDigit(c);
}
