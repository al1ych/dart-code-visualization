// @dart=2.9

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'sources.dart';

List<AstNode> contextStack = [];
Map<SimpleIdentifier, VariableDeclaration> jumpToDeclaration = {};

class VarNameResolveVisitor extends RecursiveAstVisitor {
  VarNameResolveVisitor({
    this.onVisitVariableDeclaration,
  });

  void Function(VariableDeclaration node) onVisitVariableDeclaration;

  VariableDeclaration _traceBackToDeclaration(SimpleIdentifier idNode) {
    for (int i = contextStack.length - 1; i >= 0; i--) {
      if (contextStack[i] is VariableDeclaration) {
        final VariableDeclaration decl = contextStack[i]; // down-casting
        final SimpleIdentifier declId = decl.name;
        if (declId.name == idNode.name) {
          print("for ${idNode.name} found decl at ${decl.offset}");
          return decl;
        }
      }
    }
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    final decl = _traceBackToDeclaration(node);
    jumpToDeclaration[node] = decl;
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    contextStack.add(node);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitBlock(Block block) {
    contextStack.add(block); // open block

    block.visitChildren(this); // down the tree

    while (contextStack.last.offset != block.offset) {
      // close block
      contextStack.removeLast();
    }
    contextStack.removeLast();
  }
}

bindVars(AstNode root) {}

resolveNames(AstNode root) {
  root.visitChildren(
    VarNameResolveVisitor(
      onVisitVariableDeclaration: (node) {
        // print("ast node visited: ${node.name}");
      },
    ),
  );
  // print("context stack: $contextStack");
  // bindVars(root);
}

void main(List<String> args) {
  var res = parseString(content: srcSample2);
  var root = res.unit.root;
  resolveNames(root);
  // print(jumpToDeclaration);
  for (var p in jumpToDeclaration.entries) {
    if (p.value != null) {
      print("${p.key} declared at ${p.value.offset}");
    }
  }
}
