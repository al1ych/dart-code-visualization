// @dart=2.9

part of '../../../main.dart';

void addLineNumbers(String codeString) {
  // from codeString remove duplicated \n symbols
  // while (codeString.contains("\n\n")) {
  //   codeString = codeString.replaceAll("\n\n", "\n");
  // }

  // final lines = codeString.split("\n");
  // const classes = "class='code-line'";
  // const tag1 = "<span $classes>", tag2 = "</span>";

  // int currentPosition = 0;

  // for (int i = 0; i < lines.length; i++) {
  //   final line = lines[i];
  //   final linePos = currentPosition;
  //   final lineEndPos = linePos + line.length;

  //   tags[currentFile].putIfAbsent(linePos, () => []);
  //   tags[currentFile].putIfAbsent(lineEndPos, () => []);

  //   tags[currentFile][linePos].add(tag1);
  //   tags[currentFile][lineEndPos].add(tag2);

  //   currentPosition += line.length + 1; // Add 1 for the newline character
  // }
}
