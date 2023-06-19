// @dart=2.9

part of '../../../main.dart';

void _wrapWithJumpToDeclaration(SimpleIdentifier usage, AstNode declaration) {
  final declarationPos = declaration.offset;
  final declarationFile = nodeFilePathBySignature[getNodeSignature(declaration)] ?? "";

  const classes = "class='variable-usage'";
  final events = "onclick=\"jumpTo($declarationPos, '$declarationFile')\"";
  // final events = "onclick='requestSelectFile(1)'";
  final usagePos = usage.offset;

  final tag1 = "<span id='$usagePos' $classes $events>";
  const tag2 = "</span>";

  tags[currentFile].putIfAbsent(usagePos, () => []);
  tags[currentFile].putIfAbsent(usagePos + usage.length, () => []);
  tags[currentFile][usagePos].add(tag1);
  tags[currentFile][usagePos + usage.length].add(tag2);
}

void _wrapWithUsagesList(AstNode declaration) {
  final declarationPos = declaration.offset;
  final declarationFile = nodeFilePathBySignature[getNodeSignature(declaration)] ?? "";

  List<AstNode> usages = jumpToUsages[getNodeSignature(declaration)];
  print("Usages for declaration $declaration: ");
  for (var usage in usages) {
    print(usage.offset);
  }
  String usagesListString = _getUsagesListString(usages, declaration);

  const classes = "class='variable-declaration'";
  final events = "onclick=\"showUsagesList(`$usagesListString`)\"";
  final usagePos = declaration.offset;

  final tag1 = "<span $classes $events>";
  const tag2 = "</span>";

  tags[currentFile].putIfAbsent(usagePos, () => []);
  tags[currentFile].putIfAbsent(usagePos + declaration.length, () => []);
  tags[currentFile][usagePos].add(tag1);
  tags[currentFile][usagePos + declaration.length].add(tag2);
}

String _extractLineNumber(String codeSnippet) {
  RegExp regExp = RegExp(r'at line (\d+):');
  var match = regExp.firstMatch(codeSnippet);
  if (match != null && match.groupCount >= 1) {
    return 'at line ${match.group(1)}';
  }
  return '';
}

String _getUsagesListString(List<AstNode> usages, AstNode decl) {
  String result = "";
  int index = -1;
  Map<String, int> counter = {};
  for (var usage in usages) {
    index++;
    final usagePos = usage.offset;
    final signature = getNodeSignature(usage);
    print("usage signature for usage ${usage.offset} of $decl: $signature");
    final usageFile = nodeFilePathBySignature[signature] ?? "";
    final usageFileEncoded = usageFile.codeUnits;
    final usageDescription = _getUsageDescription(usage, index);
    const classes = "class='var-pointer'";
    final events = "onclick='jumpTo($usagePos, null, $usageFileEncoded); hideUsagesList();'";
    String tag = "<span $classes $events>$usageDescription</span><br/>";

    String atLineX = _extractLineNumber(tag);
    if (counter[atLineX] == null) {
      counter[atLineX] = 1;
    } else {
      continue;
    }

    result += "$tag<br/>";
  }
  return result;
}

String _getUsageDescription(AstNode usage, int index) {
  // search in the code string for the usage and return few lines above and below
  final lines = _currentCodeString.split("\n");

  for (int i = 0; i < lines.length; i++) {
    // replace everything that's not a letter by a space
    // lines[i] = lines[i].replaceAll(RegExp(r"[^a-zA-Z]"), " ");
    // substitute quotations with spaces
    lines[i] = lines[i].replaceAll("\"", " ");
    lines[i] = lines[i].replaceAll("\'", " ");
    lines[i] = lines[i].replaceAll("<", " ");
    lines[i] = lines[i].replaceAll(">", " ");
  }

  String line = ""; // line with usage
  int offset = 0;
  for (String l in lines) {
    if (usage.offset > offset && usage.offset < offset + l.length) {
      line = l;
      break;
    }
    offset += l.length;
  }

  final lineNumber = lines.indexOf(line) + 1;
  if (lineNumber == -1) {
    return "Usage #$index not found in the source code";
  }

  final start = max(0, lineNumber - 2);
  final end = min(lines.length, lineNumber + 2);

  final resultLines = lines.sublist(start, end);
  if (index != 0) {
    resultLines.insert(0, "Usage #$index at line $lineNumber:");
  } else {
    resultLines.insert(0, "Declaration of $usage at line $lineNumber:");
  }

  for (int i = 1; i < resultLines.length; i++) {
    resultLines[i] = "${start + i + 1} | ${resultLines[i]}";
  }

  final result = resultLines.join("<br/>");
  return result;
}

String _currentCodeString = ""; // to avoid prop drilling to getUsageDescription

void addDeclarationBinding(String codeString, List<SimpleIdentifier> usages) {
  for (int i = 0; i < usages.length; i++) {
    AstNode declaration = getRootDeclaration(usages[i]);
    _wrapWithJumpToDeclaration(usages[i], declaration);
    if (declaration == usages[i]) {
      _currentCodeString = codeString;
      _wrapWithUsagesList(declaration);
    }
  }
}
