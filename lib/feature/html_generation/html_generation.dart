// @dart=2.9

part of '../../main.dart';

String get staticHTMLTemplate {
  File staticTemplateFile = File("lib/feature/html_generation/static_template.html");
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

String _bindToDeclaration(String codeString, List<SimpleIdentifier> usages) {
  if (usages.isEmpty) {
    return codeString;
  }

  // snippet to generate onclick handlers
  String generateOnClick(toWhere) {
    return "onclick='console.log($toWhere)'";
  }

  int declOffset = _getRootDeclaration(usages[0]).offset;
  String newCode = "${codeString.substring(0, usages[0].offset)}"
      "<b id='${usages[0].offset}' ${generateOnClick(declOffset)}>"
      "${usages[0].name}"
      "</b>";
  for (int i = 1; i < usages.length; i++) {
    final from = usages[i - 1].offset + usages[i - 1].length;
    final to = usages[i].offset;
    declOffset = _getRootDeclaration(usages[i]).offset;
    final newValue =
        "<b id='${usages[i].offset}' ${generateOnClick(declOffset)}>"
        "${usages[i].name}"
        "</b>";
    newCode += codeString.substring(from, to) + newValue;
  }
  newCode += codeString.substring(usages.last.offset + usages.last.length);
  return newCode;
}

String bindToDeclaration(String codeString, List<AstNode> nodes) {
  List<SimpleIdentifier> usages = [];
  for (var node in nodes) {
    AstNode dRoot = _getRootDeclaration(node); // get to the orig declaration
    usages.addAll(jumpToUsages[dRoot]); // add & flatten
  }
  usages.sort((a, b) => a.offset - b.offset); // sort by offset
  usages = usages.toSet().toList(); // remove duplicates
  return _bindToDeclaration(codeString, usages);
}

String generateHTML(String codeString, List<AstNode> usages) {
  /** html generation pipeline */
  codeString = bindToDeclaration(codeString, usages);
  codeString = codeString.replaceAll("\n", "<br/>\n");
  codeString = codeString.replaceAll("  ", "&nbsp;&nbsp;");
  codeString = "$staticHTMLTemplate <code> $codeString </code>";
  return codeString;
}
