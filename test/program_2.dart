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
  print(y);
  x *= 2;
}

void main() {
  int b = 10;
  f(b);
  x += "Hi!";
}
