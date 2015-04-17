import 'package:libgame/libgame.dart';
import 'dart:async';

main() async {
  await init();

  Room room1 = activateRoom('room1');

  List <Actor> bunnies = room1.getActorsByTag('bunny');

  stage.onMouseClick.listen((_) => activateRoom('room2'));
  stage.onMouseContextMenu.listen((_) => activateRoom('room1'));
  stage.onMouseWheel.listen((event) {
    bunnies.forEach((Actor bunny) => bunny.velocity.x += event.deltaY/50);
  });

}