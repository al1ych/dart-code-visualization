// @dart = 2.9

String x = "";

void f(int a) {
  int x = 5;
  a = x;
  {}
  int y = 1;
  if (true) {
    int y;
    y = 7;
  }
  for (int i = 0; i < 10; i++) {
    while (false) {
      // ...
    }
  }
  print(y);
  x *= 2;
}

void main() {
  int b = 10;
  f(b);
  x += "Hi!";
}
