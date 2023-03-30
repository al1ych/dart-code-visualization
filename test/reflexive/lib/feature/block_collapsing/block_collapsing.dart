// // @dart=2.9
//
// part of '../../main.dart';
//
// contextStack = [];
// Map<SimpleIdentifier, AstNode> jumpToDeclaration = {};
// Map<AstNode, List<SimpleIdentifier>> jumpToUsages = {};
//
// void _connectUsageWithDeclaration(AstNode usage, AstNode decl) {
//   jumpToDeclaration[usage] = decl;
//   if (jumpToUsages[decl] == null) {
//     jumpToUsages[decl] = [];
//   }
//   jumpToUsages[decl].add(usage);
// }
//
// AstNode _findDeclaration(SimpleIdentifier idNode) {
//   for (int i = contextStack.length - 1; i >= 0; i--) {
//     if (contextStack[i] is VariableDeclaration) {
//       VariableDeclaration decl = contextStack[i]; // down-casting
//       SimpleIdentifier declId = decl.name;
//       if (declId.name == idNode.name) {
//         return declId;
//       }
//     } else if (contextStack[i] is SimpleFormalParameter) {
//       SimpleFormalParameter decl = contextStack[i]; // down-casting
//       SimpleIdentifier declId = decl.identifier;
//       if (declId.name == idNode.name) {
//         return declId;
//       }
//     } else if (contextStack[i] is SimpleIdentifier) {
//       SimpleIdentifier declId = contextStack[i]; // down-casting
//       if (declId.name == idNode.name) {
//         return declId;
//       }
//     }
//   }
//   return null;
// }
//
// List<AstNode> get allVarUsages {
//   List<AstNode> varUsages = [];
//   for (var p in jumpToDeclaration.entries) {
//     if (p.value != null) {
//       varUsages.add(p.key);
//     }
//   }
//   return varUsages;
// }
//
// class VarNameResolveVisitor extends RecursiveAstVisitor {
//   @override
//   visitSimpleFormalParameter(SimpleFormalParameter node) {
//     final id = node.identifier;
//     contextStack.add(id);
//     return super.visitSimpleFormalParameter(node);
//   }
//
//   @override
//   void visitSimpleIdentifier(SimpleIdentifier node) {
//     AstNode decl = _findDeclaration(node);
//     _connectUsageWithDeclaration(node, decl);
//     super.visitSimpleIdentifier(node);
//   }
//
//   @override
//   void visitVariableDeclaration(VariableDeclaration node) {
//     contextStack.add(node);
//     super.visitVariableDeclaration(node);
//   }
//
//   @override
//   void visitBlock(Block block) {
//     // open block
//     contextStack.add(block);
//     // proceed down the tree
//     block.visitChildren(this);
//     // close block
//     while (contextStack.last.offset != block.offset) {
//       contextStack.removeLast();
//     }
//     contextStack.removeLast();
//   }
// }
//
// resolveNames(AstNode root) {
//   _clearAnalysisState();
//   root.visitChildren(VarNameResolveVisitor());
// }
