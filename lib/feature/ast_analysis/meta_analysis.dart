// @dart=2.9

part of '../../main.dart';

Map<String, TopLevelDeclarationInfo> topLevelDeclarations = {};
Map<AstNode, String> nodeFilePath = {};
Map<String, String> nodeFilePathBySignature = {};
// Map<AstNode, int> nodeFilePosition = {};

class TopLevelDeclarationInfo {
  AstNode node;
  String filePath;

  TopLevelDeclarationInfo({this.node, this.filePath});

  @override
  String toString() {
    return 'TLDI($node, comes-from: $filePath)';
  }
}

String getNodeSignature(AstNode node) {
  return "$node-${node.offset}";
}

class FilePathResolver extends GeneralizingAstVisitor<void> {
  final String path;

  FilePathResolver(this.path);

  @override
  void visitNode(AstNode node) {
    nodeFilePath[node] = path;
    nodeFilePathBySignature[getNodeSignature(node)] = path;
    // nodeFilePosition[node] = node.offset;
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
  // print("toppers: ${topLevelDeclarations['performOperation']}");
}
