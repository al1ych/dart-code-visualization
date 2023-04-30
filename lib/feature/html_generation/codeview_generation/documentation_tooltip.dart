// @dart=2.9

// ignore_for_file: avoid_print

part of '../../../main.dart';

Map<String, String> commentById = {};

bool isBuiltIn(String type) {
  return const [
    "int",
    "double",
    "num",
    "bool",
    "String",
    "List",
    "Map",
    "Set",
    "Iterable",
    "Future",
    "Stream",
    "Object",
    "Function",
    "Null",
    "null",
    "Type",
    "Symbol",
    "DateTime",
    "Duration",
    "Uri",
    "RegExp",
    "StackTrace",
    "IterableMixin",
    "ListMixin",
    "SetMixin",
    "MapMixin",
    "Queue",
    "LinkedList",
    "LinkedListEntry",
    "SplayTreeSet",
    "SplayTreeMap",
    "Runes",
    "Comparator",
    "Invocation",
    "Expando",
    "Endian",
    "UnmodifiableListView",
    "UnmodifiableListMixin",
    "UnmodifiableMapView",
    "UnmodifiableSetView",
  ].contains(type);
}

void addDocumentationTooltip(
  String codeString,
  List<DocumentationEntity> comments,
  List<SimpleIdentifier> usages,
) {
  const separator = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br/>";

  if (comments != null) {
    for (var comment in comments) {
      final id = "doc-${comment.offset}";
      String docText = comment.comment;
      docText = docText.replaceAll("\n", "<br/>");
      final onmousemove =
          "onmousemove=\"showTooltip(event, '$id', '$docText')\" ";
      const onmouseout = "onmouseout=\"hideTooltip()\" ";

      final tagBegin = "<span id='$id' class='doc' $onmousemove $onmouseout>";
      const tagEnd = "</span>";

      tags[currentFile].putIfAbsent(comment.offset, () => []);
      tags[currentFile][comment.offset].add(tagBegin);

      tags[currentFile].putIfAbsent(comment.offset + comment.length, () => []);
      tags[currentFile][comment.offset + comment.length].add(tagEnd);
    }
  }

  for (int i = 0; i < usages.length; i++) {
    final rootDeclaration = getRootDeclaration(usages[i]);
    final declarationPos = rootDeclaration.offset;
    final declarationId = "doc-$declarationPos";

    // print("usage: ${usages[i].name} -> $rootDeclaration");

    String docText = "";
    var n = rootDeclaration;
    int times = 2;
    while (times != 0 && n != null && n is! ClassDeclaration) {
      n = n.parent;
      times--;
    }

    if (n is ClassDeclaration) {
      if (commentById[declarationId] != null) {
        docText += commentById[declarationId];
        docText += "<br/>$separator";
      }
      docText += classDecription[n].toString();
    }

    AstNode parent = rootDeclaration.parent;
    if (parent is VariableDeclaration) {
      TypeName typeName = (parent.parent as VariableDeclarationList).type;
      String variableName = usages[i].name;

      if (typeName != null && !isBuiltIn(typeName.name.name)) {
        ClassDeclaration node = classNameToDeclaration[typeName.name.name];

        if (commentById["doc-${node.name.offset}"] != null) {
          docText += commentById["doc-${node.name.offset}"];
          docText += "<br/>$separator";
        }

        docText += "Type: ${typeName.name.name}\n";
        docText += separator;

        if (node != null) {
          docText += classDecription[node].toString();
        }
      }
    }

    docText = docText.replaceAll("\n", "<br/>");

    const classes = "";
    final onmousemove =
        "onmousemove=\"showTooltip(event, '$declarationId', '$docText')\" ";
    const onmouseout = "onmouseout=\"hideTooltip()\" ";
    final usagePos = usages[i].offset;

    final tag1 = "<span $classes $onmousemove $onmouseout>";
    const tag2 = "</span>";

    tags[currentFile].putIfAbsent(usagePos, () => []);
    tags[currentFile].putIfAbsent(usagePos + usages[i].length, () => []);

    tags[currentFile][usagePos].add(tag1);
    tags[currentFile][usagePos + usages[i].length].add(tag2);
  }
}
