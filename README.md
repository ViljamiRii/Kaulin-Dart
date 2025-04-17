# 1. Language Introduction

**Kaulin Dart** is a Finnish-inspired educational programming language implemented in Dart. It is a continuation of an earlier version of the language, **Kaulin**, originally developed in Rust. The project was initially born out of a desire to learn Rust.

Kaulin Dart aims to remain true to the spirit of the original Kaulin: the entire language is written with **Finnish syntax and keywords**. This makes it a unique tool for language learning and computing alike. If you want to write half-assed code while immersing yourself in Finnish, this is the language for you!

Kaulin Dart source files use the `.dka` file extension, short for “**Dart Kaulin**.” Programs can be run either from the command line or interactively via a REPL.

### Key features

- **Fully Finnish keyword syntax** (`muuttuja`, `jos`, `kun`, `funktio`, `paluu`, etc.)
- **Dynamic typing** with optional type annotations (e.g., `int`, `str`, `monikko`)
- **Support for basic control flow**: conditionals and loops
- **First-class functions** and return values
- **Data structures** like arrays (`joukko`) and tuples (`monikko`)
- **Simple built-in functions** such as `tulosta`, `syöte`, and `aika`
- **REPL and file-based execution**
- **C-like syntax**

### Language syntax
The following defines the grammar of Kaulin Dart in BNF.

```bnf

<program> = { <declaration> } ;

<declaration> =
      <var_declaration>
    | <typed_var_declaration>
    | <function_declaration>
    | <statement> ;

<typed_var_declaration> = <type> <identifier> "=" <expression> ";" ;

<var_declaration> = "muuttuja" <identifier> "=" <expression> ";" ;

<function_declaration> = "funktio" <identifier> "(" [ <identifier_list> ] ")" <block> ;

<identifier_list> = <identifier> { "," <identifier> } ;

<statement> =
      <expression_statement>
    | <if_statement>
    | <while_statement>
    | <for_statement>
    | <block>
    | <return_statement> ;

<expression_statement> = <expression> ";" ;

<return_statement> = "paluu" <expression> ";" ;

<if_statement> = "jos" "(" <expression> ")" <statement> [ "toisin" <statement> ] ;

<while_statement> = "kun" "(" <expression> ")" <statement> ;

<for_statement> = "toista" "(" <for_init> <for_cond> ";" <for_inc> ")" <statement> ;

<for_init> = <var_declaration> | <expression_statement> | ";" ;
<for_cond> = <expression> | ;
<for_inc> = <expression> | ;

<block> = "{" { <declaration> } "}" ;

<expression> = <assignment> ;

<assignment> = <identifier> "=" <assignment> | <equality> ;

<equality> = <comparison> { ("==" | "!=") <comparison> } ;

<comparison> = <term> { ("<" | "<=" | ">" | ">=") <term> } ;

<term> = <factor> { ("+" | "-") <factor> } ;

<factor> = <unary> { ("*" | "/" | "%") <unary> } ;

<unary> = <primary> ;

<primary> =
      <literal>
    | <identifier>
    | <array_literal>
    | <tuple_literal>
    | "(" <expression> ")"
    | <function_call> ;

<function_call> = <identifier> "(" [ <expression_list> ] ")" ;

<expression_list> = <expression> { "," <expression> } ;

<array_literal> = "[" [ <expression_list> ] "]" ;

<tuple_literal> = "(" <expression> "," <expression_list> ")" ;

<literal> =
      <number>
    | <float>
    | <string>
    | "tosi"
    | "epätosi"
    | "null" ;

<type> = "int" | "liukuluku" | "str" | "bool" | "monikko" | "joukko" ;

<identifier> = ? valid identifier ? ;
<number> = ? integer literal ? ;
<float> = ? floating-point literal ? ;
<string> = ? string literal ? ;

```

Documentation can be easily created using:

```
dart doc
dart pub global activate dhttpd
dart pub global run dhttpd --path doc/api
```



## 4. Tutorial and Exercises

You can find the full set of beginner-friendly Kaulin Dart exercises [here](examples/exercises.md).

### Project Structure

```text
.
├── CHANGELOG.md
├── README.md
├── analysis_options.yaml
├── bin
│   └── main.dart
├── doc
├── examples
│   ├── exercises.md
│   ├── fizzbuzz.dka
│   ├── hello_world.dka
│   └── laske_10_miljoonaan.dka
├── lib
│   ├── ast
│   │   └── ast_nodes.dart
│   ├── core
│   │   └── builtins.dart
│   ├── interpreter
│   │   ├── environment.dart
│   │   └── eval.dart
│   └── parser
│       ├── lexer.dart
│       ├── parser.dart
│       └── token.dart
├── pubspec.lock
├── pubspec.yaml
└── test
    ├── eval_test.dart
    ├── parser_test.dart
    └── typing_test.dart
```

---

### Original Kaulin Language

The original Kaulin language implemented in Rust can be found here:  
[https://github.com/ViljamiRii/Kaulin](https://github.com/ViljamiRii/Kaulin)