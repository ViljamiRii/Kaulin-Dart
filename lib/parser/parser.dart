import 'token.dart';
import '../ast/ast_nodes.dart';

/// A recursive descent parser that builds an AST (Abstract Syntax Tree)
/// from a list of tokens produced by the lexer.
class Parser {
  final List<Token> tokens;
  int _current = 0;

  Parser(this.tokens);

  /// Consumes a token of the expected type or throws an error.
  Token _consume(TokenType type, String message) {
    if (_check(type)) return _advance();
    throw Exception(message);
  }

  /// Parses a full program (list of statements).
  List<Stmt> parse() {
    final statements = <Stmt>[];

    while (!_isAtEnd()) {
      statements.add(_declaration());
    }

    return statements;
  }

  /// Parses a declaration (e.g., variable, function).
  Stmt _declaration() {
    if (_match([TokenType.var_])) return _varDeclaration();

    if (_match([
      TokenType.integer,
      TokenType.float,
      TokenType.stringType,
      TokenType.boolean,
      TokenType.array,
      TokenType.tuple,
    ])) {
      final typeToken = _previous();
      return _varDeclaration(typeToken.lexeme);
    }

    if (_match([TokenType.func])) return _function("function");
    if (_match([TokenType.for_])) return _forStatement();
    if (_match([TokenType.if_])) return _ifStatement();
    if (_match([TokenType.while_])) return _whileStatement();
    if (_match([TokenType.leftBrace])) return _block();
    return _expressionStatement();
  }

  /// Parses a function declaration.
  Stmt _function(String kind) {
    final name = _consume(TokenType.identifier, "Expected function name.");
    _consume(TokenType.leftParen, "Expected '(' after function name.");
    final parameters = <String>[];
    if (!_check(TokenType.rightParen)) {
      do {
        parameters.add(
          _consume(TokenType.identifier, "Expected parameter name.").lexeme,
        );
      } while (_match([TokenType.comma]));
    }
    _consume(TokenType.rightParen, "Expected ')' after parameters.");
    _consume(TokenType.leftBrace, "Expected '{' before function body.");
    final body = _block() as BlockStmt;
    return FunctionStmt(name.lexeme, parameters, body);
  }

  /// Parses a variable declaration, with optional type annotation.
  Stmt _varDeclaration([String? declaredType]) {
    if (declaredType == null &&
        _match([
          TokenType.integer,
          TokenType.float,
          TokenType.stringType,
          TokenType.boolean,
          TokenType.array,
          TokenType.tuple,
        ])) {
      declaredType = _previous().lexeme;
    }

    final nameToken = _consume(TokenType.identifier, "Expected variable name.");
    _consume(TokenType.equal, "Expected '=' after variable name.");
    final initializer = _expression();
    _consume(TokenType.semicolon, "Expected ';' after variable declaration.");

    return VarDeclarationStmt(nameToken.lexeme, initializer, declaredType);
  }

  /// Parses a while loop.
  Stmt _whileStatement() {
    _consume(TokenType.leftParen, "Expected '(' after 'while'.");
    final condition = _expression();
    _consume(TokenType.rightParen, "Expected ')' after while condition.");
    final body = _declaration();
    return WhileStmt(condition, body);
  }

  /// Parses a for loop and desugars it into a while loop.
  Stmt _forStatement() {
    _consume(TokenType.leftParen, "Expected '(' after 'for'.");

    Stmt? initializer;
    if (_match([TokenType.var_])) {
      initializer = _varDeclaration();
    } else if (!_check(TokenType.semicolon)) {
      initializer = _expressionStatement();
    } else {
      _advance();
    }

    Expr condition = LiteralExpr(true, LiteralType.boolean);
    if (!_check(TokenType.semicolon)) {
      condition = _expression();
    }
    _consume(TokenType.semicolon, "Expected ';' after loop condition.");

    Expr? increment;
    if (!_check(TokenType.rightParen)) {
      increment = _expression();
    }
    _consume(TokenType.rightParen, "Expected ')' after for clauses.");

    Stmt body = _declaration();

    if (increment != null) {
      body = BlockStmt([body, ExpressionStmt(increment)]);
    }

    body = WhileStmt(condition, body);

    if (initializer != null) {
      body = BlockStmt([initializer, body]);
    }

    return body;
  }

  /// Parses an if statement.
  Stmt _ifStatement() {
    _consume(TokenType.leftParen, "Expected '(' after 'if'.");
    final condition = _expression();
    _consume(TokenType.rightParen, "Expected ')' after if condition.");

    final thenBranch = _declaration();
    Stmt? elseBranch;

    if (_match([TokenType.else_])) {
      elseBranch = _declaration();
    }

    return IfStmt(condition, thenBranch, elseBranch);
  }

  /// Parses a block of statements inside `{}`.
  Stmt _block() {
    final statements = <Stmt>[];

    while (!_check(TokenType.rightBrace) && !_isAtEnd()) {
      statements.add(_declaration());
    }

    _consume(TokenType.rightBrace, "Expected '}' after block.");
    return BlockStmt(statements);
  }

  /// Parses a return or standalone expression statement.
  Stmt _expressionStatement() {
    if (_match([TokenType.return_])) {
      final value = _expression();
      _consume(TokenType.semicolon, "Expected ';' after return value.");
      return ReturnStmt(value);
    }
    final expr = _expression();
    _consume(TokenType.semicolon, "Expected ';' after expression.");
    return ExpressionStmt(expr);
  }

  /// Entry point for expression parsing.
  Expr _expression() => _assignment();

  /// Parses assignment expressions.
  Expr _assignment() {
    final expr = _equality();

    if (_match([TokenType.equal])) {
      final value = _assignment();

      if (expr is IdentifierExpr) {
        return AssignmentExpr(expr.name, value);
      }

      throw Exception("Invalid assignment target.");
    }

    return expr;
  }

  /// Parses equality expressions (==, !=).
  Expr _equality() {
    Expr expr = _comparison();

    while (_match([TokenType.equalEqual, TokenType.bangEqual])) {
      Token operator = _previous();
      Expr right = _comparison();
      expr = BinaryExpr(expr, operator.lexeme, right);
    }

    return expr;
  }

  /// Parses comparison expressions (<, <=, >, >=).
  Expr _comparison() {
    Expr expr = _term();

    while (_match([
      TokenType.less,
      TokenType.lessEqual,
      TokenType.greater,
      TokenType.greaterEqual,
    ])) {
      Token operator = _previous();
      Expr right = _term();
      expr = BinaryExpr(expr, operator.lexeme, right);
    }

    return expr;
  }

  /// Parses addition and subtraction.
  Expr _term() {
    Expr expr = _factor();

    while (_match([TokenType.plus, TokenType.minus])) {
      Token operator = _previous();
      Expr right = _factor();
      expr = BinaryExpr(expr, operator.lexeme, right);
    }

    return expr;
  }

  /// Parses multiplication, division, and modulus.
  Expr _factor() {
    Expr expr = _primary();

    while (_match([TokenType.star, TokenType.slash, TokenType.modulus])) {
      Token operator = _previous();
      Expr right = _primary();
      expr = BinaryExpr(expr, operator.lexeme, right);
    }

    return expr;
  }

  /// Parses primary expressions including literals, tuples, arrays, and grouped expressions.
  Expr _primary() {
    if (_match([TokenType.leftBracket])) {
      final elements = <Expr>[];
      if (!_check(TokenType.rightBracket)) {
        do {
          elements.add(_expression());
        } while (_match([TokenType.comma]));
      }
      _consume(TokenType.rightBracket, "Expected ']' after array elements.");
      return ArrayExpr(elements);
    }
    if (_match([TokenType.false_]))
      return LiteralExpr(false, LiteralType.boolean);
    if (_match([TokenType.true_]))
      return LiteralExpr(true, LiteralType.boolean);
    if (_match([TokenType.null_])) return LiteralExpr(null, LiteralType.null_);

    if (_match([TokenType.number])) {
      return LiteralExpr(_previous().literal, LiteralType.integer);
    }

    if (_match([TokenType.float])) {
      return LiteralExpr(_previous().literal, LiteralType.float);
    }

    if (_match([TokenType.string])) {
      return LiteralExpr(_previous().literal, LiteralType.string);
    }

    if (_match([TokenType.identifier])) {
      return _finishCall(IdentifierExpr(_previous().lexeme));
    }

    if (_match([TokenType.leftParen])) {
      if (_check(TokenType.rightParen)) {
        _advance();
        return TupleExpr([]);
      }
      final first = _expression();
      if (_match([TokenType.comma])) {
        final elements = <Expr>[first];
        do {
          elements.add(_expression());
        } while (_match([TokenType.comma]));
        _consume(TokenType.rightParen, "Expected ')' after tuple.");
        return TupleExpr(elements);
      } else {
        _consume(TokenType.rightParen, "Expected ')' after expression.");
        return first;
      }
    }

    throw Exception("Expected expression.");
  }

  /// Parses a function call expression if parentheses follow an identifier.
  Expr _finishCall(Expr callee) {
    if (!_match([TokenType.leftParen])) return callee;

    final args = <Expr>[];

    if (!_check(TokenType.rightParen)) {
      do {
        args.add(_expression());
      } while (_match([TokenType.comma]));
    }

    _consume(TokenType.rightParen, "Expected ')' after arguments.");
    return CallExpr(callee, args);
  }

  /// Tries to match any of the provided token types.
  bool _match(List<TokenType> types) {
    for (final type in types) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }
    return false;
  }

  /// Checks if the current token matches the expected type.
  bool _check(TokenType type) {
    if (_isAtEnd()) return false;
    return _peek().type == type;
  }

  /// Advances to the next token.
  Token _advance() {
    if (!_isAtEnd()) _current++;
    return _previous();
  }

  /// Returns true if we've consumed all tokens.
  bool _isAtEnd() => _peek().type == TokenType.eof;

  /// Returns the current token.
  Token _peek() => tokens[_current];

  /// Returns the most recently consumed token.
  Token _previous() => tokens[_current - 1];
}
