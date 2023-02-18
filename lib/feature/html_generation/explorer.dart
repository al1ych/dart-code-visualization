// @dart=2.9

// ignore_for_file: avoid_print

part of '../../main.dart';

String get explorerTemplate {
  String path = "${Directory.current.path}"
      "/feature/html_generation/resources/explorer.template.html";
  File staticTemplateFile = File(path);
  String staticTemplateContent = staticTemplateFile.readAsStringSync();
  return staticTemplateContent;
}

class FileData {
  String filename;
  String filePath;
  FileData({this.filename, this.filePath});
  @override
  String toString() {
    return "{filename: $filename, filePath: $filePath}";
  }
}

String getExplorerHTML(List<FileData> files) {
  String filesHTML = files
      .map((fd) => "{"
          "name: '${fd.filename}', "
          "uri: '${fd.filePath}'}")
      .toList()
      .join(",\n");

  String explorerViewContent = "<div id='explorer-view-content'>\n";
  for (int i = 0; i < files.length; i++) {
    explorerViewContent += "  <ul id='$i' onclick='selectFile($i)'></ul>\n";
  }
  explorerViewContent += "</div>\n";

  return "$explorerTemplate\n"
      "$explorerViewContent\n"
      "<script>\n"
      "const files = [$filesHTML]\n"
      "</script>\n";
}
