// @dart=2.9

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'sources.dart';

List<AstNode> contextStack = [];
Map<SimpleIdentifier, AstNode> jumpToDeclaration = {};

class VarNameResolveVisitor extends RecursiveAstVisitor {
  VarNameResolveVisitor({
    this.onVisitVariableDeclaration,
  });

  void Function(VariableDeclaration node) onVisitVariableDeclaration;

  AstNode _findDeclaration(SimpleIdentifier idNode) {
    for (int i = contextStack.length - 1; i >= 0; i--) {
      if (contextStack[i] is VariableDeclaration) {
        VariableDeclaration decl = contextStack[i]; // down-casting
        SimpleIdentifier declId = decl.name;
        if (declId.name == idNode.name) {
          return decl;
        }
      } else if (contextStack[i] is SimpleFormalParameter) {
        SimpleFormalParameter decl = contextStack[i];  // down-casting
        SimpleIdentifier declId = decl.identifier;
        if (declId.name == idNode.name) {
          return decl;
        }
      }
    }
    return null;
  }

  @override
  visitSimpleFormalParameter(SimpleFormalParameter node) {
    contextStack.add(node);
    return super.visitSimpleFormalParameter(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    AstNode decl = _findDeclaration(node);
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
    contextStack.add(block);                            // open block

    block.visitChildren(this);                          // down the tree

    while (contextStack.last.offset != block.offset) {  // close block
      contextStack.removeLast();
    }
    contextStack.removeLast();
  }
}

bindVars(AstNode root) {}

resolveNames(AstNode root) {
  root.visitChildren(
    VarNameResolveVisitor(),
  );
  // bindVars(root);
}

void main(List<String> args) {
  var res = parseString(content: srcSample2);
  var root = res.unit.root;
  resolveNames(root);
  print(jumpToDeclaration);
  for (var p in jumpToDeclaration.entries) {
    if (p.value != null) {
      print("${p.key}:${p.key.runtimeType} declared at ${p.value.offset}");
    }
  }
}
