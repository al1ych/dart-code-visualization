// @dart=2.9

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'sources.dart';

part 'name_resolution.dart';

void main(List<String> args) {
  var res = parseString(content: srcSample2);
  var root = res.unit.root;
  resolveNames(root);
  // print(jumpToDeclaration);
  for (var p in jumpToDeclaration.entries) {
    if (p.value != null) {
      print("${p.key} declared at ${p.value.offset}");
      // print("${p.key}:${p.key.runtimeType} declared at ${p.value.offset}");
    }
  }
}
