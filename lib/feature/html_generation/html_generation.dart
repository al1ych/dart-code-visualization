// @dart=2.9

// ignore_for_file: avoid_print

part of '../../main.dart';

String get layoutTemplate {
  String path = "${Directory.current.path}"
      "/feature/html_generation/resources/layout.template.html";
  File staticTemplateFile = File(path);
  String staticTemplateContent = staticTemplateFile.readAsStringSync();
  return staticTemplateContent;
}

String get codeviewTemplate {
  String path = "${Directory.current.path}"
      "/feature/html_generation/resources/codeview.template.html";
  File staticTemplateFile = File(path);
  String staticTemplateContent = staticTemplateFile.readAsStringSync();
  return staticTemplateContent;
}

String get explorerTemplate {
  String path = "${Directory.current.path}"
      "/feature/html_generation/resources/explorer.template.html";
  File staticTemplateFile = File(path);
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

String getExplorerHTML(List<FileData> files) {
  String filesHTML = files
      .map((fd) => "{"
          "name: '${fd.filename}', "
          "uri: '${fd.filePath}'}")
      .toList()
      .join(",\n");
  return "$explorerTemplate\n"
      "<script>\n"
      "const files = [$filesHTML]\n"
      "</script>\n";
}

String getCodeviewHTML(String codeString, List<AstNode> usages) {
  codeString = initializePipeline(codeString, usages);
  codeString = "$codeviewTemplate\n"
      "<pre><code>$codeString</code></pre>\n";
  return codeString;
}

String generateCodeviewHTML(
  String filename,
  String codeString,
  List<AstNode> usages,
) {
  final cvPath = "../build/html/$filename.codeview.html";
  var cvHTML = getCodeviewHTML(codeString, usages);

  File cvFile = File(cvPath);
  cvFile.writeAsStringSync(cvHTML);
  return cvPath;
}

class FileData {
  String filename;
  String filePath;
  FileData({this.filename, this.filePath});
  @override
  String toString() {
    return "{filename: $filename, filePath: $filePath}";
  }
}

String getLayoutHTML(List<String> filePaths) {
  final files = filePaths
      .map((fp) => FileData(
            filename: fp.split("/").last,
            filePath: '${Directory.current.path}/$fp',
          ))
      .toList();

  final explorerHTML = getExplorerHTML(files);

  return "$layoutTemplate\n"
      "<div class='grid'>\n"
      "<div class='left-pane'>\n"
      "<!-- EXPLORER START -->\n"
      "$explorerHTML\n"
      "<!-- EXPLORER END -->\n"
      "</div>\n"
      "<div class='right-pane'>\n"
      "<iframe id='codeview'>\n"
      "</div>\n"
      "</div>\n";
}

String generateLayoutHTML(
  String filename,
  List<String> filePaths,
) {
  final path = "../build/html/$filename.db.html";
  var html = getLayoutHTML(filePaths);
  File file = File(path);
  file.writeAsStringSync(html);
  return path;
}
