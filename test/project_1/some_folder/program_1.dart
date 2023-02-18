void main() {
  int x = 1, y = 2;
  {
    int x = 1, y = 2;
    print("hello world! x $x : $y");
  }
  // =>
  x;
  y;
}
