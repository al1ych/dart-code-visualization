// @dart=2.9

// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'feature/syntax_highlighting/syntax_highlighting.dart';
part 'feature/ast_analysis/ast_analysis.dart';
part 'feature/html_generation/codeview_generation/codeview.dart';
part 'feature/html_generation/layout.dart';
part 'feature/html_generation/explorer.dart';
part 'feature/html_generation/codeview_generation/block_collapsers.dart';
part 'feature/html_generation/codeview_generation/var_binding.dart';
part 'feature/html_generation/codeview_generation/syntax_highlighting.dart';
part 'feature/html_generation/codeview_generation/documentation_tooltip.dart';
part 'feature/ast_analysis/comment_analysis.dart';

String currentFile = '';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide the project title as an argument.');
    exit(1);
  }

  String projectTitle = args[0];

  List<String> sources = [];
  Directory dir = Directory('../test/$projectTitle');

  dir.listSync(recursive: true).forEach((file) {
    if (file is File && file.path.endsWith('.dart')) {
      sources.add(file.path);
    }
  });

  print("sources: $sources");

  List<String> cvPaths = [];

  for (int i = 0; i < sources.length; i++) {
    String filePath = sources[i];
    print("filePath: $filePath");
    // String filename = filePath.split('/').last.split('.').first;
    List<String> pathComponents = filePath.split('/');
    int projectTitleIndex = pathComponents.indexOf(projectTitle);
    String filename = pathComponents.skip(projectTitleIndex + 1).join('/');

    currentFile = filename;
    File codeFile = File(filePath);
    String code = codeFile.readAsStringSync();

    var res = parseString(content: code);
    var root = res.unit.root;

    startAnalysis(root); // ast walking

    print("Processing source file: $filename.dart...");
    String cvPath = generateCodeviewHTML(filename, code, allVarUsages);
    cvPaths.add(cvPath);
  }

  String ltPath = generateLayoutHTML(projectTitle, cvPaths);

  print("DartBoard is ready!");
  bool autorun = false;
  if (autorun) {
    print("Opening ${ltPath.split('/').last}...");
    if (Platform.isMacOS) {
      Process.run('open', [ltPath]).then((result) {
        stdout.write(result.stdout);
        stderr.write(result.stderr);
      });
    } else if (Platform.isWindows) {
      Process.run('start', [ltPath], runInShell: true).then((result) {
        stdout.write(result.stdout);
        stderr.write(result.stderr);
      });
    } else if (Platform.isLinux) {
      Process.run('xdg-open', [ltPath]).then((result) {
        stdout.write(result.stdout);
        stderr.write(result.stderr);
      });
    }
  }
}
