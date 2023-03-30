// @dart=2.9

// ignore_for_file: avoid_print

part of '../../main.dart';

String get layoutTemplate {
  String path = "${Directory.current.path}"
      "/feature/html_generation/resources/layout.template.html";
  File staticTemplateFile = File(path);
  String staticTemplateContent = staticTemplateFile.readAsStringSync();
  return staticTemplateContent;
}

String getLayoutHTML(List<String> filePaths) {
  final files = filePaths
      .map((fp) => FileData(
            // filename: "${fp.split("/").last.split(".").first}.dart",
            filename: "${fp.split("/html/").last.split(".").first}.dart",
            filePath:
                '${Directory.current.path}/$fp', // filepath is for DartBoard (its path to build/ generated)
          ))
      .toList();

  final explorerHTML = getExplorerHTML(files);

  return "$layoutTemplate\n"
      "<div class='grid'>\n"
      "<div class='left-pane'>\n"
      "<!-- EXPLORER START -->\n"
      "$explorerHTML\n"
      "<!-- EXPLORER END -->\n"
      "</div>\n"
      "<div class='right-pane'>\n"
      "<iframe id='codeview'>\n"
      "</div>\n"
      "</div>\n";
}

String generateLayoutHTML(
  String filename,
  List<String> filePaths,
) {
  final path = "../build/html/$filename.db.html";
  var html = getLayoutHTML(filePaths);
  File file = File(path);
  file.writeAsStringSync(html);
  return path;
}
