/// Defines built-in functions for Kaulin Dart.
/// These are core functions available in the interpreter by default.
///
/// Functions include:
/// - `tulosta`: prints to stdout
/// - `syöte`: reads a line of input
/// - `aika`: returns the current time in milliseconds since midnight

import 'dart:io';
import 'dart:core';

/// A map of built-in function names to their implementations.
final builtInFunctions = <String, Object? Function(List<Object?>)>{
  /// Prints its arguments joined by space.
  /// Example: `tulosta("Hei", "maailma")` prints `Hei maailma`
  'tulosta': (args) {
    print(args.map(kaulinToString).join(' '));
    return null;
  },

  /// Reads a line of input from the user.
  /// Optional prompt text can be provided as the first argument.
  /// Example: `syöte("Nimesi: ")`
  'syöte': (args) {
    stdout.write(args.isNotEmpty ? args.first.toString() : '');
    return stdin.readLineSync();
  },

  /// Returns the current time in milliseconds since midnight.
  /// Useful for timing operations.
  'aika': (args) {
    return DateTime.now().millisecond +
        1000 * DateTime.now().second +
        60000 * DateTime.now().minute +
        3600000 * DateTime.now().hour;
  },
};

String kaulinToString(Object? value) {
  if (value == true) return 'tosi';
  if (value == false) return 'epätosi';
  if (value == null) return 'tyhjä';
  return value.toString();
}
