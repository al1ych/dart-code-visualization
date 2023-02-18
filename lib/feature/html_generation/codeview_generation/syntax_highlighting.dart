// @dart=2.9

part of '../../../main.dart';

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
