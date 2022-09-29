void f(int a) {
  int x = 5;   // decl
  a = x;       // ass
  { }          // empty block
  int y = 1;   // decl
  if (true) {  // if stmt
    int y;     // decl
    y = 7;     // ass
  }            // if stmt
  print(y);    // usage
}

void main() {
  int b = 10;  // decl
  f(b);        // usage
}
