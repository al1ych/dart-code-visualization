// @dart=2.9

part of '../../main.dart';

class ClassInfo {
  String name;
  String modifiers;
  String extendedClass;
  List<String> implementedInterfaces;
  List<String> mixins;
  List<String> fieldNames;
  List<String> methodNames;
  List<String> constructorNames;

  ClassInfo({
    this.name,
    this.modifiers,
    this.extendedClass,
    this.implementedInterfaces,
    this.mixins,
    this.fieldNames,
    this.methodNames,
    this.constructorNames,
  });
}

class ClassInfoVisitor extends RecursiveAstVisitor<void> {
  List<ClassInfo> classInfos = [];

  String getModifiers(ClassDeclaration node) {
    List<String> modifierKeywords = [];
    if (node.isAbstract) {
      modifierKeywords.add('abstract');
    }
    // Add other modifiers as needed
    return modifierKeywords.join(' ');
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    String className = node.name.name;
    String modifiers = getModifiers(node);

    String extendedClass;
    if (node.extendsClause != null) {
      extendedClass = node.extendsClause.superclass.name.name;
    } else {
      extendedClass = '';
    }

    List<String> implementedInterfaces;
    if (node.implementsClause != null) {
      implementedInterfaces = node.implementsClause.interfaces
          .map((interface) => interface.name.name)
          .toList();
    } else {
      implementedInterfaces = [];
    }

    List<String> mixins;
    if (node.withClause != null) {
      mixins =
          node.withClause.mixinTypes.map((mixin) => mixin.name.name).toList();
    } else {
      mixins = [];
    }

    List<String> fieldNames = [];
    List<String> methodNames = [];
    List<String> constructorNames = [];

    node.members.forEach((member) {
      if (member is FieldDeclaration) {
        // Field
        member.fields.variables.forEach((variable) {
          fieldNames.add(variable.name.name);
        });
      } else if (member is MethodDeclaration) {
        // Method
        methodNames.add(member.name.name);
      } else if (member is ConstructorDeclaration) {
        // Constructor
        constructorNames.add(member.name?.name ?? className);
      }
    });

    classInfos.add(ClassInfo(
      name: className,
      modifiers: modifiers,
      extendedClass: extendedClass,
      implementedInterfaces: implementedInterfaces,
      mixins: mixins,
      fieldNames: fieldNames,
      methodNames: methodNames,
      constructorNames: constructorNames,
    ));

    // print out classInfo for each class
    for (ClassInfo classInfo in classInfos) {
      print("--------------------------------------------------");
      print('Class name: ${classInfo.name}');
      print('Modifiers: ${classInfo.modifiers}');
      print('Extended class: ${classInfo.extendedClass}');
      print('Implemented interfaces: ${classInfo.implementedInterfaces}');
      print('Mixins: ${classInfo.mixins}');
      print('Field names: ${classInfo.fieldNames}');
      print('Method names: ${classInfo.methodNames}');
      print('Constructor names: ${classInfo.constructorNames}');
      print("--------------------------------------------------");
    }

    super.visitClassDeclaration(node);
  }
}
