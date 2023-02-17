// @dart=2.9

part of "../../main.dart";

enum EventType { closes, opens }

class Event {
  int i;
  int x;
  EventType type;

  Event({this.i, this.x, this.type});
}

String addBlockCollapsers(String codeString, List<AstNode> blocks) {
  // pipeline step #2: map and wrap all the elements to highlight syntax
  // this one implements the scanline algorithm
  // html of code -> html of code
  // todo решение накладываемых индексов: считать j который i
  // todo за исключением хтмл-ных тегов которые добавляются
  // todo на других этапах : то есть добавляем в черный список
  // todo все символы которые составляют хтмл-теги и потом игнорим при подсчете j

  // todo пофиксить накладывание блоков со всех файлов в каждый: нужно на каждый файл держать свои блоки

  String newCode = "";
  List<Event> e = [];
  for (int i = 0; i < blocks.length; i++) {
    e.add(Event(
      i: i,
      x: blocks[i].offset,
      type: EventType.opens,
    ));
    e.add(Event(
      i: i,
      x: blocks[i].offset + blocks[i].length,
      type: EventType.closes,
    ));
  }
  e.sort((Event a, Event b) => a.x - b.x);
  for (int i = 0; i < e.length; i++) {
    print(
        "Event #${e[i].i}: ${e[i].type} : ${e[i].x} - block: ${blocks[e[i].i]}");
    final b = (i == 0
        ? codeString.substring(0, e[i].x)
        : codeString.substring(e[i - 1].x, e[i].x));
    if (e[i].type == EventType.opens) {
      final id = "block-${e[i].i}";
      const classes = "block";
      final events = "onclick='collapse(`$id`)'";
      newCode += "$b<spoiler id='$id' class='$classes' $events>";
    } else {
      newCode += "$b</spoiler>";
    }
  }
  return newCode;
}
