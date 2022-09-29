// @dart=2.9
// deprecated

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
    int x;      // decl
    a = x;      // ass
    {}
    int y;      // decl
    if (true) { // if stmt
      int y;    // decl
      y = 7;    // ass
    }           // if stmt
    print(y);
  }
  
  void main() {
    int b = 10;
    f(b);
  }
""";