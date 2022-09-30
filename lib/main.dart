// @dart=2.9

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'feature/name_resolution.dart';

part 'feature/html_generation/html_generation.dart';

void main(List<String> args) {
  String filename = 'program_2';
  File codeFile = File('test/$filename.dart');
  String codeString = codeFile.readAsStringSync();

  var res = parseString(content: codeString);
  var root = res.unit.root;

  resolveNames(root);

  print("Generating HTML from code source...");
  var genHtml = generateHTML(codeString, allVarUsages);
  final outPath = "build/html/${filename}_dartboard.html";
  print("Dumping HTML into file...");
  File outFile = File(outPath);
  outFile.writeAsStringSync(genHtml);
  print("Success! Access HTML here: $outPath.");
  print("Automatically opening the HTML...");
  Process.run('open', [outPath]).then((result) {
    // probably macos only
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  });
}
