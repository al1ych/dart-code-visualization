// @dart=2.9

part of '../../../main.dart';

void _wrapWithJumpToDeclaration(SimpleIdentifier usage, AstNode declaration) {
  final declarationPos = declaration.offset;
  final declarationFile = nodeFilePath[declaration] ?? "";

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
  final declarationFile = nodeFilePath[declaration] ?? "";

  List<AstNode> usages = jumpToUsages[declaration];
  print("Usages for declaration: $declaration");
  String usagesListString = _getUsagesListString(usages);

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

String _getUsagesListString(List<AstNode> usages) {
  String result = "";
  for (var usage in usages) {
    final usagePos = usage.offset;
    final usageFile = nodeFilePathBySignature["$usage-${usage.offset}"] ?? "";
    print("Usage node: $usage, file: $usageFile");

    // encode into array to bypass html escaping
    final usageFileEncoded = usageFile.codeUnits;
    // print("node: $usage file: $usageFile encode: $usageFileEncoded");
    const classes = "class='var-pointer'";
    final events =
        "onclick='jumpTo($usagePos, null, $usageFileEncoded); hideUsagesList();'";
    String tag = "<span $classes $events>$usage</span>";
    result += "$tag<br/>";
  }
  return result;
}

void addDeclarationBinding(String codeString, List<SimpleIdentifier> usages) {
  for (int i = 0; i < usages.length; i++) {
    AstNode declaration = getRootDeclaration(usages[i]);
    _wrapWithJumpToDeclaration(usages[i], declaration);
    if (declaration == usages[i]) {
      _wrapWithUsagesList(declaration);
    }
  }
}
