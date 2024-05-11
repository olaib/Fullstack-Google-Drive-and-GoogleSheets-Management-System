import 'dart:collection';
import 'dart:math';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/logger/logger.dart';

// test sheet operators below
void main() {
  // Create some cells
  final cells = [
    ['10.0', '20', '30'],
    ['40', '50', '60'],
    ['70', '80', '90'],
  ];

  // Create a sheet
  final sheet = SheetOperator();
  //test expressions
  final expressions = <String>[
    '2 * A1 + 2 * A3',
    '3 * A2 + 5 / A1 - 1',
    'A1 + ( A2 * A3) - 10',
    'A1 ^ A1 + 3 ^ 2',
    'dsdasd + 2',
    'B33',
    '2',
    'ABss',
    'ABb',
    'A2B2'
  ];
  for (final expression in expressions) {
    final isValid =
        sheet.isValidExpression(expression, cells[0].length, cells.length);

    if (isValid) {
      Log.debug('$expression: ${sheet.evaluate(expression, cells)}');
    } else {
      Log.debug('$expression = $isValid');
    }
  }
  // Evaluate an expression
  Log.debug(sheet.evaluate('A1 + B2', cells));
}

//TODO: Implement the SheetOperator class in the sheet tabel widget
class SheetOperator {
  /// Check if the expression is valid by:
  /// 1. Checking if the parenthesis are balanced
  /// 2. Checking if the cell references are within the range
  /// 3. Checking if the expression is valid mathematically
  /// [expression] The expression to validate
  /// [maxColumn] The maximum number of columns
  /// [maxRow] The maximum number of rows
  /// Returns true if the expression is valid, false otherwise
  bool isValidExpression(String expression, int maxColumn, int maxRow) {
    // extract ( and ) from expression and validate if they are balanced
    final openParenthesisCount = expression.split('(').length - 1;
    final closeParenthesisCount = expression.split(')').length - 1;
    if (openParenthesisCount != closeParenthesisCount) {
      return false;
    }
    // remove ( and ) from expression
    expression = expression.replaceAll(RegExp(r'[()]'), '');
    if (EXPRESSION_REGEX.hasMatch(expression)) {
      final extractCells = CELL_REGEX.allMatches(expression);
      // validate if cell references are within the range
      for (final cell in extractCells) {
        final cellName = cell.group(0)!;
        final column = cellName.codeUnitAt(0) - 'A'.codeUnitAt(0);
        final row = int.parse(cellName.substring(1)) - 1;
        if (column >= maxColumn || row >= maxRow) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  double evaluate(String expression, List<List<String>> cells) {
    final updatedExpression = _replaceCellReferences(expression, cells);
    final tokens = _tokenize(updatedExpression);
    final queue = _shuntingYard(tokens);
    return _evaluatePostfix(queue);
  }

  String _replaceCellReferences(String expression, List<List<String>> cells) {
    final cellMap = <String, String>{};
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        final cellValue = cells[i][j];
        final cellName =
            String.fromCharCode('A'.codeUnitAt(0) + j) + (i + 1).toString();
        cellMap[cellName] = cellValue;
      }
    }

    final updatedExpression = expression.splitMapJoin(
      RegExp(r'[A-Z]\d+'),
      onMatch: (m) => cellMap[m.group(0)]!,
      onNonMatch: (n) => n,
    );
    return updatedExpression;
  }

  List<String> _tokenize(String expression) {
    final List<String> tokens = [];
    String current = '';

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];
      if (char == ' ') continue;

      if (_isOperator(char) || char == '(' || char == ')') {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        tokens.add(char);
      } else if (char == EXPONENT) {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        tokens.add(EXPONENT);
      } else {
        current += char;
      }
    }

    if (current.isNotEmpty) tokens.add(current);

    return tokens;
  }

  bool _isOperator(String token) => OPERATORS.contains(token);

  Queue<String> _shuntingYard(List<String> tokens) {
    final output = Queue<String>();
    final stack = Queue<String>();

    for (final token in tokens) {
      if (_isOperator(token)) {
        while (stack.isNotEmpty &&
            _operatorPrecedence(stack.last) >= _operatorPrecedence(token)) {
          output.addLast(stack.removeLast());
        }
        stack.addLast(token);
      } else if (token == '(') {
        stack.addLast(token);
      } else if (token == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output.addLast(stack.removeLast());
        }
        if (stack.isNotEmpty && stack.last == '(') {
          stack.removeLast(); // Discard '('
        }
      } else {
        output.addLast(token);
      }
    }
    while (stack.isNotEmpty) {
      output.addLast(stack.removeLast());
    }
    return output;
  }

  int _operatorPrecedence(String op) => switch (op) {
        (ADD || SUBTRACT) => 1,
        (MULTIPLY || DIVIDE) => 2,
        (EXPONENT) => 3,
        (_) => 0,
      };

  double _evaluatePostfix(Queue<String> queue) {
    final stack = Queue<double>();

    while (queue.isNotEmpty) {
      final token = queue.removeFirst();

      double result = 0;
      if (_isOperator(token)) {
        if (token == '^') {
          result = eveluatePower(token, stack);
        } else {
          result = evaluateOperation(token, stack);
        }
      } else {
        result = double.parse(token);
      }
      stack.addLast(result);
    }

    return stack.single;
  }

  eveluatePower(String expression, Queue<double> stack) {
    final exponent = stack.removeLast().toInt();
    final base = stack.removeLast();
    return pow(base, exponent).toDouble();
  }

  double evaluateOperation(String token, Queue<double> stack) {
    final b = stack.removeLast();
    final a = stack.removeLast();
    return switch (token) {
      (ADD) => a + b,
      (SUBTRACT) => a - b,
      (MULTIPLY) => a * b,
      (DIVIDE) => a / b,
      (_) => 0,
    };
  }
}
