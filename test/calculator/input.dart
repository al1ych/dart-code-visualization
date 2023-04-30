// @dart=2.9

part of 'main.dart';

int getInput(String prompt) {
  print(prompt);
  return int.parse(stdin.readLineSync());
}

String getOperation() {
  print('Enter operation:');
  return stdin.readLineSync();
}
