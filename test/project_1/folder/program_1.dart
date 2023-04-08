void main() {
  int x = 1, y = 2;
  {
    int x = 1, y = 2;
    print("hello world! x $x : $y");
  }

  /// =>
  x;
  y;
}

/// documentation?
int someFunction1() {
  /// stuff
}

// documentation?
int someFunction2() {
  /// stuff
}

/* documentation */
int someFunction3() {
  /// stuff
}

/**
 * documentation
 *  */
int someFunction4() {
  /// stuff
}

int someFunction() {
  /**
   * documentation
   *  */
}
