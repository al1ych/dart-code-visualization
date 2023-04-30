library pets;

abstract class Pet {
  String name;
  Pet(this.name);

  void makeSound();
}

class Dog extends Pet {
  Dog(String name) : super(name);

  @override
  void makeSound() {
    print("$name says: Woof!");
  }
}

/// cat
class Cat extends Pet {
  Cat(String name) : super(name);

  @override
  void makeSound() {
    print("$name says: Meow!");
  }
}
