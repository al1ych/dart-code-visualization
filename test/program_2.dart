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
}

void main() {
  int b = 10;
  f(b);
}
