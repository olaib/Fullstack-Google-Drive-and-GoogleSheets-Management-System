// ignore_for_file: depend_on_referenced_packages

import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger();

  static void debug(dynamic message) {
    _logger.d(message);
  }

  static void info(dynamic message) {
    _logger.i(message);
  }

  static void warning(dynamic message) {
    _logger.w(message);
  }

  static void error(dynamic message) {
    _logger.e(message);
  }
}
