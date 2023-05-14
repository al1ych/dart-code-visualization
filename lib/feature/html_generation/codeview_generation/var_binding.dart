// @dart=2.9

part of '../../../main.dart';

void _wrapWithJumpToDeclaration(SimpleIdentifier usage, AstNode declaration) {
  final declarationPos = declaration.offset;
  final declarationFile =
      nodeFilePathBySignature[getNodeSignature(declaration)] ?? "";

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
  final declarationFile =
      nodeFilePathBySignature[getNodeSignature(declaration)] ?? "";

  List<AstNode> usages = jumpToUsages[getNodeSignature(declaration)];
  print("Usages for declaration $declaration: $usages");
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

String _getUsagesListString(List<AstNode> usages, AstNode decl) {
  String result = "";
  for (var usage in usages) {
    final usagePos = usage.offset;
    final signature = getNodeSignature(usage);
    final usageFile = nodeFilePathBySignature[signature] ?? "";
    print("Usage node: $usage, file: $usageFile");
    print(
        "Decl node: $decl, file: ${nodeFilePathBySignature[getNodeSignature(decl)]}");
    // encode into array to bypass html escaping
    final usageFileEncoded = usageFile.codeUnits;
    // print("node: $usage file: $usageFile encode: $usageFileEncoded");
    // usage desc should take few lines above and below it in the source code
    final usageDescription = _getUsageDescription(usage);
    const classes = "class='var-pointer'";
    final events =
        "onclick='jumpTo($usagePos, null, $usageFileEncoded); hideUsagesList();'";
    String tag = "<span $classes $events>$usageDescription</span><br/>";
    result += "$tag<br/>";
  }
  return result;
}

// todo show USAGE's line, not declaration's
String _getUsageDescription(AstNode usage) {
  final lines = _currentCodeString.split("\n");
  final line =
      lines.where((element) => element.contains(usage.toString())).first;
  final lineNumber = lines.indexOf(line) + 1;
  const window = 1;
  final start = max(0, lineNumber - window);
  final end = min(lines.length, lineNumber + window);
  final linesToTake = lines.sublist(start, end);
  // add line numbers to each
  for (int i = 0; i < linesToTake.length; i++) {
    linesToTake[i] = "Line ${start + i + 1}: ${linesToTake[i]}";
  }
  final result = linesToTake.join("<br/>");
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
