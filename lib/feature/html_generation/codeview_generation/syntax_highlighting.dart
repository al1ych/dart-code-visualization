// @dart=2.9

part of '../../../main.dart';

void addSimpleSyntaxHighlighting(String codeString) {
  for (RegExp regExp in SyntaxHighlighting.codePatterns.keys) {
    List<RegExpMatch> matches = regExp.allMatches(codeString).toList();
    final color = SyntaxHighlighting.codePatterns[regExp];
    for (int i = matches.length - 1; i >= 0; i--) {
      final classes = "class='$color'";

      final tag1 = "<span $classes>";
      const tag2 = "</span>";

      tags[currentFile].putIfAbsent(matches[i].start, () => []);
      tags[currentFile].putIfAbsent(matches[i].end, () => []);

      tags[currentFile][matches[i].start].add(tag1);
      tags[currentFile][matches[i].end].add(tag2);
    }
  }
}
