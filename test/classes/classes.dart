// @dart=2.9

/**
 * Person describes a person,
 * with a name and an age,
 * and can introduce themselves.
 */
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Hello, my name is $name and I am $age years old.');
  }
}

class Employee extends Person {
  String jobTitle;

  Employee(String name, int age, this.jobTitle) : super(name, age);

  @override
  void introduce() {
    super.introduce();
    print("I work as a $jobTitle.");
  }
}

// abstract classes and implementations

abstract class Shape {
  double get area;
}

class Circle implements Shape {
  final double radius;

  Circle(this.radius);

  @override
  double get area => pi * pow(radius, 2);
}

class Square implements Shape {
  final double side;

  Square(this.side);

  @override
  double get area => pow(side, 2);
}

void main() {
  Person person = Person('John Doe', 30);
  person.introduce();

  Employee employee = Employee('Jane Doe', 28, 'Software Engineer');
  employee.introduce();

  Circle circle = Circle(2);
  Square square = Square(2);

  print(circle.area);
  print(square.area);
}








//