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

String _wrapUsage(String usage, int uPos, int dPos) {
  const classes = "class='variable-usage'";
  return "<span $classes id='$uPos' onclick='jumpTo($dPos)'>$usage</span>";
}

// String _wrapBlock(String block, int bPos) {
//   const classes = "class='block'";
//   final id = "id='$bPos'";
//   const events = "";
//   return "<span $classes $id $events>$block</span>";
// }

String addDeclarationBinding(String codeString, List<SimpleIdentifier> usages) {
  // pipeline step: wrap all the usages, give id and declaration pointer
  // html of code -> html of code
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

enum EventType { closes, opens }

class Event {
  int i;
  int x;
  EventType type;

  Event({this.i, this.x, this.type});
}

String addBlockCollapsers(String codeString, List<AstNode> blocks) {
  // pipeline step #2: map and wrap all the elements to highlight syntax
  // this one implements the scanline algorithm
  // html of code -> html of code
  // todo решение накладываемых индексов: считать j который i
  // todo за исключением хтмл-ных тегов которые добавляются
  // todo на других этапах : то есть добавляем в черный список
  // todo все символы которые составляют хтмл-теги и потом игнорим при подсчете j
  String newCode = "";
  List<Event> e = [];
  for (int i = 0; i < blocks.length; i++) {
    e.add(Event(
      i: i,
      x: blocks[i].offset,
      type: EventType.opens,
    ));
    e.add(Event(
      i: i,
      x: blocks[i].offset + blocks[i].length,
      type: EventType.closes,
    ));
  }
  e.sort((Event a, Event b) => a.x - b.x);
  for (int i = 0; i < e.length; i++) {
    print("Event #${e[i].i}: ${e[i].type} : ${e[i].x}");
    final b = (i == 0
        ? codeString.substring(0, e[i].x)
        : codeString.substring(e[i - 1].x, e[i].x));
    if (e[i].type == EventType.opens) {
      newCode += "$b<span class='block'>";
    } else {
      newCode += "$b</span>";
    }
  }
  return newCode;
}

String _wrapColor(String match, String colorClass) {
  final classes = "class='$colorClass'";
  return "<span $classes>$match</span>";
}

String addSimpleSyntaxHighlighting(String codeString) {
  // pipeline step: map and wrap all the elements to highlight syntax
  // html of code -> html of code
  for (RegExp regExp in SyntaxHighlighting.codePatterns.keys) {
    List<RegExpMatch> matches = regExp.allMatches(codeString).toList();
    final color = SyntaxHighlighting.codePatterns[regExp];
    for (int i = matches.length - 1; i >= 0; i--) {
      final before = codeString.substring(0, matches[i].start);
      final match = codeString.substring(matches[i].start, matches[i].end);
      final after = codeString.substring(matches[i].end);
      codeString = before + _wrapColor(match, color) + after;
    }
  }
  return codeString;
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
  processedCode = addBlockCollapsers(processedCode, blocks);
  // processedCode = addDeclarationBinding(processedCode, usages);
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
