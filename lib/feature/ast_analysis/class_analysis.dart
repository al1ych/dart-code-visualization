// @dart=2.9

part of '../../main.dart';

Map<AstNode, ClassInfo> classDecription = {};

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

  @override
  String toString() {
    List<String> output = [
      // '--------------------------------------------------',
      '> Class name: $name',
      if (modifiers.isNotEmpty) '> Modifiers: $modifiers',
      if (extendedClass.isNotEmpty) '> Extended class: $extendedClass',
      if (implementedInterfaces.isNotEmpty)
        '> Implemented interfaces: $implementedInterfaces',
      if (mixins.isNotEmpty) '> Mixins: $mixins',
      if (fieldNames.isNotEmpty) '> Field names: $fieldNames',
      if (methodNames.isNotEmpty) '> Method names: $methodNames',
      if (constructorNames.isNotEmpty) '> Constructor names: $constructorNames',
      // '--------------------------------------------------',
    ];
    return output.join('\n');
  }
}

class ClassInfoVisitor extends RecursiveAstVisitor<void> {
  String getModifiers(ClassDeclaration node) {
    List<String> modifierKeywords = [];
    if (node.isAbstract) {
      modifierKeywords.add('abstract');
    }
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

    classDecription[node] = ClassInfo(
      name: className,
      modifiers: modifiers,
      extendedClass: extendedClass,
      implementedInterfaces: implementedInterfaces,
      mixins: mixins,
      fieldNames: fieldNames,
      methodNames: methodNames,
      constructorNames: constructorNames,
    );

    // for (ClassInfo classInfo in classDecription.values) {
    //   print("--------------------");
    //   print(classInfo);
    //   print("--------------------");
    // }

    super.visitClassDeclaration(node);
  }
}

Map<String, ClassDeclaration> classNameToDeclaration = {};

class ClassNameToDeclarationVisitor extends RecursiveAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    classNameToDeclaration[node.name.name] = node;
    super.visitClassDeclaration(node);
  }
}
