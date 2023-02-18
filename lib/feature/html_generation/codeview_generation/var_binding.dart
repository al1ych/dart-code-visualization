// @dart=2.9

part of '../../../main.dart';

String _wrapUsage(String usage, int uPos, int dPos) {
  const classes = "class='variable-usage'";
  return "<span $classes id='$uPos' onclick='jumpTo($dPos)'>$usage</span>";
}

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
