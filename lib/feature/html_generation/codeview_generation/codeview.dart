// @dart=2.9

// ignore_for_file: avoid_print

part of '../../../main.dart';

Map<String, Map<int, List<String>>> tags = {}; // each file -> map<pos, tags>

String get codeviewTemplate {
  String path = "${Directory.current.path}"
      "/feature/html_generation/resources/codeview.template.html";
  File staticTemplateFile = File(path);
  String staticTemplateContent = staticTemplateFile.readAsStringSync();
  return staticTemplateContent;
}

String executePipeline(String codeString) {
  // sort tag keys
  final keys = tags[currentFile].keys.toList();
  keys.sort();
  String newCode = codeString;
  // iterate over keys from end to beginning
  for (int i = keys.length - 1; i >= 0; i--) {
    final pos = keys[i];
    final ts = tags[currentFile][pos];
    // if class doc then print
    for (int j = 0; j < ts.length; j++) {
      final t = ts[j];
      newCode = newCode.substring(0, pos) + t + newCode.substring(pos);
    }
  }
  return newCode;
}

String codeviewPipeline(
  String codeString,
  List<SimpleIdentifier> usages,
  List<AstNode> blocks,
) {
  // decl binding goes before documentation tooltip
  addBlockCollapsers(codeString, blocks);
  addDeclarationBinding(codeString, usages);
  addDocumentationTooltip(codeString, comments[currentFile], usages);
  addSimpleSyntaxHighlighting(codeString);
  addLineNumbers(codeString);
  return executePipeline(codeString);
}

String initializeCodeviewPipeline(String codeString, List<AstNode> nodes) {
  List<SimpleIdentifier> usages = [];
  for (var node in nodes) {
    AstNode dRoot = getRootDeclaration(node); // get to the orig declaration
    usages.addAll(jumpToUsages[getNodeSignature(dRoot)]); // add & flatten
  }
  usages.sort((a, b) => a.offset - b.offset); // sort by offset
  usages = usages.toSet().toList(); // remove duplicates
  return codeviewPipeline(codeString, usages, blocks[currentFile]);
}

String getCodeviewHTML(String originalCode, List<AstNode> usages) {
  String newCode = originalCode;
  newCode = initializeCodeviewPipeline(newCode, usages);
  newCode = "$codeviewTemplate\n"
      "<pre><code id='code-section'>$newCode</code></pre>\n"
      "<pre><code id='original-code-section'>$originalCode</code></pre>\n"
      "</div>\n"
      "</div>\n";
  return newCode;
}

String generateCodeviewHTML(
  String filename,
  String codeString,
  List<AstNode> usages,
) {
  final cvPath = "../build/html/$filename.codeview.html";
  var cvHTML = getCodeviewHTML(codeString, usages);

  File cvFile = File(cvPath);

  // Create necessary directories
  cvFile.parent.createSync(recursive: true);

  cvFile.writeAsStringSync(cvHTML);
  return cvPath;
}
