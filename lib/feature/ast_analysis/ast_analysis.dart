// @dart=2.9

part of '../../main.dart';

List<AstNode> contextStack = [];
List<AstNode> blocksBuffer = [];
Map<String, List<AstNode>> blocks = {}; // blocks of particular file
Map<SimpleIdentifier, AstNode> jumpToDeclaration = {};
Map<AstNode, List<SimpleIdentifier>> jumpToUsages = {};

void _clearAnalysisState() {
  contextStack = [];
  jumpToDeclaration = {};
  jumpToUsages = {};
  blocksBuffer = [];
}

void _connectUsageWithDeclaration(AstNode usage, AstNode decl) {
  jumpToDeclaration[usage] = decl;
  if (jumpToUsages[decl] == null) {
    jumpToUsages[decl] = [];
  }
  jumpToUsages[decl].add(usage);
}

AstNode _findDeclaration(SimpleIdentifier idNode) {
  for (int i = contextStack.length - 1; i >= 0; i--) {
    if (contextStack[i] is VariableDeclaration) {
      VariableDeclaration decl = contextStack[i]; // down-casting
      SimpleIdentifier declId = decl.name;
      if (declId.name == idNode.name) {
        return declId;
      }
    } else if (contextStack[i] is SimpleFormalParameter) {
      SimpleFormalParameter decl = contextStack[i]; // down-casting
      SimpleIdentifier declId = decl.identifier;
      if (declId.name == idNode.name) {
        return declId;
      }
    } else if (contextStack[i] is SimpleIdentifier) {
      SimpleIdentifier declId = contextStack[i]; // down-casting
      if (declId.name == idNode.name) {
        return declId;
      }
    } else if (contextStack[i] is FunctionDeclaration) {
      FunctionDeclaration decl = contextStack[i]; // down-casting
      SimpleIdentifier declId = decl.name;
      if (declId.name == idNode.name) {
        return declId;
      }
    }
  }
  return null;
}

List<AstNode> get allVarUsages {
  List<AstNode> varUsages = [];
  for (var p in jumpToDeclaration.entries) {
    if (p.value != null) {
      varUsages.add(p.key);
    }
  }
  return varUsages;
}

class NameResolveAndContextStackVisitor extends RecursiveAstVisitor {
  /////////////////////////////
  /// Visiting Declarations

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    contextStack.add(node);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    SimpleIdentifier id = node.name;
    contextStack.add(id);
    super.visitFunctionDeclaration(node);
  }

  /////////////////////////////
  /// Visiting Usages

  @override
  visitSimpleFormalParameter(SimpleFormalParameter node) {
    final id = node.identifier;
    contextStack.add(id);
    return super.visitSimpleFormalParameter(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    AstNode decl = _findDeclaration(node);
    _connectUsageWithDeclaration(node, decl);
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    AstNode decl = _findDeclaration(node.methodName);
    _connectUsageWithDeclaration(node.methodName, decl);
    super.visitMethodInvocation(node);
  }

  /////////////////////////////
  /// Forming block stack

  @override
  void visitBlock(Block block) {
    // open block
    contextStack.add(block);
    blocksBuffer.add(block);
    // proceed down the tree
    block.visitChildren(this);
    // close block
    while (contextStack.last.offset != block.offset) {
      contextStack.removeLast();
    }
    contextStack.removeLast();
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    print("ClassDeclaration: ${node}");
    // Open class block
    contextStack.add(node);
    blocksBuffer.add(node);
    // Proceed down the tree
    node.visitChildren(this);
    // Close class block
    contextStack.removeLast();
  }
}

startAnalysis(AstNode root) {
  _clearAnalysisState();
  root.visitChildren(NameResolveAndContextStackVisitor());
  root.visitChildren(DocumentationCommentVisitor());
  blocks[currentFile] = blocksBuffer;
}
