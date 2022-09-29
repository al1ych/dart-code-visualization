// @dart=2.9

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'sources.dart';

List<VariableDeclaration> varDeclarations = [];
List<VariableDeclaration> contextStack = [];


class RecursiveVariableDeclarationVisitor extends RecursiveAstVisitor {
  RecursiveVariableDeclarationVisitor({
    this.onVisitVariableDeclaration,
  });

  void Function(VariableDeclaration node) onVisitVariableDeclaration;

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    print("visitSimpleIdentifier id: $node");
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    onVisitVariableDeclaration(node);
    super.visitVariableDeclaration(node);
  }
}

bindVariables() {}

resolveNames() {
  bindVariables();
}

void main(List<String> args) {
  var res = parseString(content: srcSample1);

  res.unit.root.visitChildren(
    RecursiveVariableDeclarationVisitor(onVisitVariableDeclaration: (node) {
      print("ast node visited: ${node.name}");
    }),
  );
}
