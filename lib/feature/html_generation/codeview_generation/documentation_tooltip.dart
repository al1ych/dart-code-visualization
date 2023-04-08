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

    const events = "onmouseover='showTooltip(event)' "
        "onmouseout='hideTooltip(event)' "
        "onmousemove='moveTooltip(event)'";
    final id = "doc-${comment.offset}";
    final tagBegin = "<span id='$id' class='doc' $events>";
    const tagEnd = "</span>";

    tags[currentFile].putIfAbsent(comment.offset, () => []);
    tags[currentFile][comment.offset].add(tagBegin);

    tags[currentFile].putIfAbsent(comment.offset + comment.length, () => []);
    tags[currentFile][comment.offset + comment.length].add(tagEnd);

    // todo 1 : add function usage-declaration flow as well
    // todo 2 : like with var usage-declaration, onmouseover=showTooltip(getRootDeclaration(for each entity))
  }
}
