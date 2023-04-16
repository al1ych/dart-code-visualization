// @dart=2.9

part of '../../main.dart';

class DocumentationEntity {
  final String comment;
  final int offset;
  final int length;

  DocumentationEntity(this.comment, this.offset, this.length);
}

Map<String, List<DocumentationEntity>> comments = {}; // {file->{entity->docs}}

class DocumentationCommentVisitor extends RecursiveAstVisitor<void> {
  void handleAnnotatedNode(AnnotatedNode node) {
    final documentationComment = node.documentationComment;
    if (documentationComment != null) {
      final String content = documentationComment.tokens
          .map(
            (t) => t.toString(),
          )
          .join('\n');
      final comment = DocumentationEntity(
        content,
        documentationComment.offset,
        documentationComment.length,
      );
      if (comments[currentFile] == null) {
        comments[currentFile] = [];
      }
      comments[currentFile].add(comment);

      if (node is FunctionDeclaration) {
        SimpleIdentifier functionName = node.name;
        commentById["doc-${functionName.offset}"] = comment.comment;
      }
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    handleAnnotatedNode(node);
    super.visitClassDeclaration(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    handleAnnotatedNode(node);
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    handleAnnotatedNode(node);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    handleAnnotatedNode(node);
    super.visitFieldDeclaration(node);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    handleAnnotatedNode(node);
    super.visitTopLevelVariableDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    handleAnnotatedNode(node);
    super.visitFunctionDeclaration(node);
  }
}
