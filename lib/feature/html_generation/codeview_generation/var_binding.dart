// @dart=2.9

part of '../../../main.dart';

String _wrapUsage(String usage, int uPos, int dPos) {
  const classes = "class='variable-usage'";
  return "<span $classes id='$uPos' onclick='jumpTo($dPos)'>$usage</span>";
}

void addDeclarationBinding(String codeString, List<SimpleIdentifier> usages) {
  for (int i = 0; i < usages.length; i++) {
    final declaration = getRootDeclaration(usages[i]);
    final declarationPos = declaration.offset;
    final declarationFile = nodeFilePath[declaration] ?? "";

    // print("declaration: $declaration -> nodeFilePath: $declarationFile");
    // print(
    //     "current file from addDeclarationBinding: $currentFile, "
    //     "declaration file: $declarationFile");
    // if (currentFile.split("/").last != declarationFile.split("/").last) {
    //   print("!usage ${usages[i]} resides in $currentFile!");
    //   print(
    //       "!declaration $declaration resides in diff file: $declarationFile!");
    // }

    const classes = "class='variable-usage'";
    final events = "onclick=\"jumpTo($declarationPos, '$declarationFile')\"";
    // final events = "onclick='requestSelectFile(1)'";
    final usagePos = usages[i].offset;

    final tag1 = "<span id='$usagePos' $classes $events>";
    const tag2 = "</span>";

    tags[currentFile].putIfAbsent(usagePos, () => []);
    tags[currentFile].putIfAbsent(usagePos + usages[i].length, () => []);

    tags[currentFile][usagePos].add(tag1);
    tags[currentFile][usagePos + usages[i].length].add(tag2);
  }
}
