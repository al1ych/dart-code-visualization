// @dart=2.9

part of 'main.dart';

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
        SimpleFormalParameter decl = contextStack[i]; // down-casting
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
    // open block
    contextStack.add(block);
    // proceed down the tree
    block.visitChildren(this);
    // close block
    while (contextStack.last.offset != block.offset) {
      contextStack.removeLast();
    }
    contextStack.removeLast();
  }
}

resolveNames(AstNode root) {
  root.visitChildren(
    VarNameResolveVisitor(),
  );
}
