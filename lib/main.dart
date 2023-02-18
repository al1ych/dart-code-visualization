// @dart=2.9

// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:developer';
import 'dart:io';
// import 'package:flutter/material.dart';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'feature/syntax_highlighting/syntax_highlighting.dart';
part 'feature/name_resolution/name_resolution.dart';
part 'feature/html_generation/html_generation.dart';
part 'feature/html_generation/block_collapsers.dart';
part 'feature/html_generation/var_binding.dart';
part 'feature/html_generation/syntax_highlighting.dart';

String currentFile = '';

void main(List<String> args) {
  const projectTitle = 'project_1';

  // mock data
  // List<String> sources = [
  //   'program_1',
  //   'program_2',
  //   'program_3',
  //   'program_long'
  // ];

  // get all dart files in a folder
  List<String> sources = [];
  Directory dir = Directory('../test/$projectTitle');
  dir.listSync().forEach((file) {
    if (file.path.endsWith('.dart')) {
      sources.add(file.path.split('/').last.split('.').first);
    }
  });

  print("sources: $sources");

  List<String> cvPaths = [];

  for (int i = 0; i < sources.length; i++) {
    String filename = sources[i];

    currentFile = filename;
    File codeFile = File('../test/$projectTitle/$filename.dart');
    String code = codeFile.readAsStringSync();

    var res = parseString(content: code);
    var root = res.unit.root;

    startAnalysis(root); // ast walking

    // print("Blocks:");
    // for (int i = 0; i < blocks.length; i++) {
    //   print("${blocks[i]} +++++ ${blocks[i].offset} + ${blocks[i].length}");
    // }

    print("Processing source file: $filename.dart...");
    String cvPath = generateCodeviewHTML(filename, code, allVarUsages);
    cvPaths.add(cvPath);
  }

  String ltPath = generateLayoutHTML(projectTitle, cvPaths);

  print("DartBoard is ready! Opening ${ltPath.split('/').last}...");
  Process.run('open', [ltPath]).then((result) {
    // probably macos only
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  });
}
