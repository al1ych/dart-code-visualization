// @dart=2.9

part of '../../../main.dart';

enum EventType { closes, opens }

class Event {
  int i;
  int x;
  EventType type;

  Event({this.i, this.x, this.type});
}

void addBlockCollapsers(String codeString, List<AstNode> blocks) {
  // pipeline step #2: map and wrap all the elements to highlight syntax
  // this one implements the scanline algorithm
  // html of code -> html of code
  // todo решение накладываемых индексов: считать j который i
  // todo за исключением хтмл-ных тегов которые добавляются
  // todo на других этапах : то есть добавляем в черный список
  // todo все символы которые составляют хтмл-теги и потом игнорим при подсчете j
  tags[currentFile] = {};
  String newCode = "";
  List<Event> e = [];
  for (int i = 0; i < blocks.length; i++) {
    int blockStart;
    int blockEnd;

    if (blocks[i] is ClassDeclaration) {
      final classNode = blocks[i] as ClassDeclaration;
      blockStart = classNode.leftBracket.offset;
      blockEnd = classNode.rightBracket.end;
    } else {
      blockStart = blocks[i].offset;
      blockEnd = blocks[i].offset + blocks[i].length;
    }

    e.add(Event(
      i: i,
      x: blockStart,
      type: EventType.opens,
    ));
    e.add(Event(
      i: i,
      x: blockEnd,
      type: EventType.closes,
    ));
  }

  e.sort((Event a, Event b) => a.x - b.x);

  for (int i = 0; i < e.length; i++) {
    // var blockName = (blocks[e[i].i] is ClassDeclaration
    //     ? (blocks[e[i].i] as ClassDeclaration).name.name
    //     : "noName");
    // print(
    //     "Event #${e[i].i}: ${e[i].type} : ${e[i].x} - block: $blockName : ${blocks[e[i].i]}");
    final b = (i == 0
        ? codeString.substring(0, e[i].x)
        : codeString.substring(e[i - 1].x, e[i].x));
    if (e[i].type == EventType.opens) {
      String content = b;
      final id = "block-${e[i].i}";
      const classes = "block";
      final events = "oncontextmenu='collapse(`$id`)'";
      final tag = "<span id='$id' class='$classes' $events>";
      tags[currentFile].putIfAbsent(e[i].x, () => []);
      tags[currentFile][e[i].x].add(tag);
    } else {
      String content = b;
      const tag = "</span>";
      tags[currentFile].putIfAbsent(e[i].x, () => []);
      tags[currentFile][e[i].x].add(tag);
    }
  }
}
