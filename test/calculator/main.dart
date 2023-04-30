// @dart=2.9

import 'dart:io';

part 'logic.dart';
part 'input.dart';

void main() {
  int a = getInput('Enter first number:');
  int b = getInput('Enter second number:');
  String operation = getOperation();

  int result = performOperation(a, b, operation);

  if (result != null) {
    print('Result: $result');
  } else {
    print('Invalid operation');
  }
}
