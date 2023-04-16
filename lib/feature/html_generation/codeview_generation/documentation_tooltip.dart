// @dart=2.9

// ignore_for_file: avoid_print

part of '../../../main.dart';

Map<String, String> commentById = {};

void addDocumentationTooltip(
  String codeString,
  List<DocumentationEntity> comments,
  List<SimpleIdentifier> usages,
) {
  if (comments == null) {
    return;
  }

  for (var comment in comments) {
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
  }

  for (int i = 0; i < usages.length; i++) {
    final rootDeclaration = getRootDeclaration(usages[i]);
    final declarationPos = rootDeclaration.offset;
    final declarationId = "doc-$declarationPos";

    const classes = "";
    final docText = ""
        "${commentById[declarationId] ?? ''}";
    final events = ""
        "onmousemove=\"showTooltip(event, '$declarationId', '$docText')\" "
        "onmouseout=\"hideTooltip(event, '$declarationId', '$docText')\" ";
    final usagePos = usages[i].offset;

    final tag1 = "<span $classes $events>";
    const tag2 = "</span>";

    tags[currentFile].putIfAbsent(usagePos, () => []);
    tags[currentFile].putIfAbsent(usagePos + usages[i].length, () => []);

    tags[currentFile][usagePos].add(tag1);
    tags[currentFile][usagePos + usages[i].length].add(tag2);
  }
}
