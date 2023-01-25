// @dart=2.9

part of '../../main.dart';

String get staticHTMLTemplate {
  File staticTemplateFile =
      File("lib/feature/html_generation/resources/static_template.html");
  String staticTemplateContent = staticTemplateFile.readAsStringSync();
  return staticTemplateContent;
}

AstNode _getRootDeclaration(AstNode node) {
  while (jumpToDeclaration[node] != null &&
      jumpToDeclaration[node].offset != node.offset) {
    node = jumpToDeclaration[node];
  }
  return node;
}

String pipeline(
  String codeString,
  List<SimpleIdentifier> usages,
  List<AstNode> blocks,
) {
  if (usages.isEmpty) {
    return codeString;
  }
  String processedCode = codeString;
  // processedCode = addBlockCollapsers(processedCode, blocks);
  processedCode = addDeclarationBinding(processedCode, usages);
  processedCode = addSimpleSyntaxHighlighting(processedCode);
  return processedCode;
}

String initializePipeline(String codeString, List<AstNode> nodes) {
  List<SimpleIdentifier> usages = [];
  for (var node in nodes) {
    AstNode dRoot = _getRootDeclaration(node); // get to the orig declaration
    usages.addAll(jumpToUsages[dRoot]); // add & flatten
  }
  usages.sort((a, b) => a.offset - b.offset); // sort by offset
  usages = usages.toSet().toList(); // remove duplicates
  return pipeline(codeString, usages, blocks);
}

String generateHTML(String codeString, List<AstNode> usages) {
  /** html generation pipeline */
  codeString = initializePipeline(codeString, usages);
  codeString = "$staticHTMLTemplate"
      "<pre><code>$codeString</code></pre>";
  return codeString;
}
