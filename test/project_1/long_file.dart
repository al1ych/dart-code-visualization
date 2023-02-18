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
  for (int i = 0; i < 100000; i++) {
    while (false) {
      // ...
    }
  }
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
  print(y);
  x *= 2;
}

// more functions like this
int g(int a, int b) {
  return a + b;
}

String zIndex() {
  return "z-index: 1;";
}
