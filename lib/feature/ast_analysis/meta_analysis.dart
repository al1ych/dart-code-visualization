// @dart=2.9

part of '../../main.dart';

Map<String, TopLevelDeclarationInfo> topLevelDeclarations = {};
Map<AstNode, String> nodeFilePath = {};

class TopLevelDeclarationInfo {
  AstNode node;
  String filePath;

  TopLevelDeclarationInfo({this.node, this.filePath});

  @override
  String toString() {
    return 'TLDI($node, comes-from: $filePath)';
  }
}

class FilePathResolver extends GeneralizingAstVisitor<void> {
  final String path;

  FilePathResolver(this.path);

  @override
  void visitNode(AstNode node) {
    nodeFilePath[node] = path;
    // print("node: $node --- path: $path");
    super.visitNode(node);
  }
}

class ToppersVisitor extends GeneralizingAstVisitor {
  final String filePath;

  ToppersVisitor(this.filePath);

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    SimpleIdentifier id = node.name;
    topLevelDeclarations[id.name] =
        TopLevelDeclarationInfo(node: id, filePath: filePath);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    SimpleIdentifier id = node.name;
    topLevelDeclarations[id.name] =
        TopLevelDeclarationInfo(node: id, filePath: filePath);
    super.visitFunctionDeclaration(node);
  }

  // top level class declaration
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    SimpleIdentifier id = node.name;
    topLevelDeclarations[id.name] =
        TopLevelDeclarationInfo(node: id, filePath: filePath);
    super.visitClassDeclaration(node);
  }
}

startMetaAnalysis(AstNode root, String filePath) {
  root.visitChildren(FilePathResolver(filePath));
  root.visitChildren(ToppersVisitor(filePath));
}
