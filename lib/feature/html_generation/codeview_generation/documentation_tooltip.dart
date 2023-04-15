// @dart=2.9

// ignore_for_file: avoid_print

part of '../../../main.dart';

void addDocumentationTooltip(
  String codeString,
  List<DocumentationEntity> comments,
) {
  if (comments == null) {
    return;
  }
  // for each comment in comments print
  // its text and its offset
  print("comments:");
  for (var comment in comments) {
    // print(
    // "comment: ${comment.comment} at ${comment.offset} ends at ${comment.offset + comment.length}");

    final id = "doc-${comment.offset}";
    final docText = /* comment.comment but remove all \n chars */
        comment.comment.replaceAll("\n", "\\n");
    final events = ""
        "onmousemove=\"showTooltip(event, '$id', '$docText')\" "
        "onmouseout=\"hideTooltip(event, '$id', '$docText')\" ";
    final tagBegin = "<span id='$id' class='doc' $events>";
    const tagEnd = "</span>";

    tags[currentFile].putIfAbsent(comment.offset, () => []);
    tags[currentFile][comment.offset].add(tagBegin);

    tags[currentFile].putIfAbsent(comment.offset + comment.length, () => []);
    tags[currentFile][comment.offset + comment.length].add(tagEnd);

    // [x] todo 1 : add function usage-declaration flow as well
    // [ ] todo   : повесить тег на каждый декларейшон что к нему относится конкретный коммент
    // [ ] todo 2 : like with var usage-declaration, onmouseover=showTooltip(getRootDeclaration(for each entity))
  }
}
