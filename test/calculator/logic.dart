// @dart=2.9

part of 'main.dart';

int performOperation(int a, int b, String operation) {
  int result;
  switch (operation) {
    case '+':
      result = a + b;
      break;
    case '-':
      result = a - b;
      break;
    case '*':
      result = a * b;
      break;
    case '/':
      if (b != 0) {
        result = a ~/ b;
      } else {
        print("Division by zero is not allowed.");
        result = null;
      }
      break;
    default:
      result = null;
  }
  return result;
}
