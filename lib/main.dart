// @dart=2.9

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'feature/name_resolution.dart';

part 'feature/refactoring.dart';

void main(List<String> args) {
  File codeFile = File('test/program_2.dart');
  String codeString = codeFile.readAsStringSync();

  var res = parseString(content: codeString);
  var root = res.unit.root;

  resolveNames(root);

  // print(jumpToDeclaration);
  for (var p in jumpToDeclaration.entries) {
    if (p.value != null) {
      // print("${p.key} declared at ${p.value.offset}");
      if (p.key.name == 'x') {
        // todo node replacer ?
        // String newCode = wrapWithTag(codeString, p.key, '<tag>');
        // print(newCode);
        // break;
      }

      print("${p.key}:${p.key.runtimeType}:${p.key.offset} -> "
          "${p.value}:${p.value.runtimeType}:${p.value.offset} ");
    }
  }
}
