// @dart=2.9

part of 'main.dart';

const srcSample1 = """
  void main() {
    int x = 1, y = 2;
    {
      int x = 1, y = 2;
      print("hello world! \$x : \$y");
    }
  }
""";

const srcSample2 = """
  void f(int a) {
    int x;
    a = x;
    int y;
    if (true) {
      int y;
      y = 7;
    }
  }
""";