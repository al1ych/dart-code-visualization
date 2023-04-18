/// A simple test class.
class TestClass {
  /// A simple integer field.
  int exampleField;

  /// Default constructor.
  TestClass(this.exampleField);

  /// Increments the `exampleField` by 1.
  void increment() {
    exampleField++;
  }

  /// A top-level function that returns the square of the given integer.
  int topLevelFunction(int value) {
    return value * value;
  }
}

void f() {
  TestClass testClass = TestClass(0);
  testClass.increment();
}
