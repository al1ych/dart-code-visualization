// @dart=2.9

part of '../../main.dart';

String get staticHTMLTemplate {
  File staticTemplateFile =
      File("lib/feature/html_generation/static_template.html");
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

String _genOnClick(toWhere) {
  return "onclick='jumpTo($toWhere)'";
}

String _wrapUsage(String usage, int uPos, int dPos) {
  const classes = "class='variable-usage'";
  return "<span $classes id='$uPos' ${_genOnClick(dPos)}>$usage</span>";
}

String addDeclarationBinding(String codeString, List<SimpleIdentifier> usages) {
  // pipeline step #1: wrap all the usages, give id and declaration pointer
  // html of code -> html of code
  // todo идти с конца
  String newCode = "";
  for (int i = 0; i < usages.length; i++) {
    final from = (i == 0 ? 0 : usages[i - 1].offset + usages[i - 1].length);
    final to = usages[i].offset;
    final declPos = _getRootDeclaration(usages[i]).offset;
    String substituted = usages[i].name;
    substituted = _wrapUsage(substituted, usages[i].offset, declPos);
    newCode += codeString.substring(from, to) + substituted;
  }
  newCode += codeString.substring(usages.last.offset + usages.last.length);
  return newCode;
}

String _wrapColor(String match, String colorClass) {
  final classes = "class='$colorClass'";
  return "<span $classes>$match</span>";
}

String addSimpleSyntaxHighlighting(String codeString) {
  // pipeline step #2: map and wrap all the elements to highlight syntax
  // html of code -> html of code

  for (RegExp regExp in SyntaxHighlighting.codePatterns.keys) {
    List<RegExpMatch> matches = regExp.allMatches(codeString).toList();
    final color = SyntaxHighlighting.codePatterns[regExp];

    print("New regex!!! ${regExp.pattern}");

    for (int i = matches.length - 1; i >= 0; i--) {
      final before = codeString.substring(0, matches[i].start);
      final match = codeString.substring(matches[i].start, matches[i].end);
      print("---------substituting $match--------------------");
      print(codeString);
      print("------------------------------------------------");
      final after = codeString.substring(matches[i].end);
      codeString = before + _wrapColor(match, color) + after;
    }

    // print("Matches found for ${regExp.pattern}: "
    //     "${matches.map((RegExpMatch e) => e.start)}");
  }

  return codeString;
}

String pipeline(String codeString, List<SimpleIdentifier> usages) {
  if (usages.isEmpty) {
    return codeString;
  }
  String processedCode = codeString;
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
  return pipeline(codeString, usages);
}

String generateHTML(String codeString, List<AstNode> usages) {
  /** html generation pipeline */
  codeString = initializePipeline(codeString, usages);
  codeString = "$staticHTMLTemplate"
      "<pre><code>$codeString</code></pre>";
  return codeString;
}
