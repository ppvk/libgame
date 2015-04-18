import 'package:libgame/libgame.dart';
import 'dart:async';
import 'dart:html';

main() async {
  await init();

  print(keybinds);

  Room room1 = activateRoom('room1');

  List <Actor> bunnies = room1.getActorsByTag('bunny');

  for (Actor bunny in bunnies) {
    bunny.sprite.sprite.onMouseClick.listen((_) {
      bunny.force.impulse(25, 3, 5);
    });
  }

  document.onKeyUp.listen((event) {
    bunnies.forEach((Actor bunny) {
      bunny.velocity.y -= 3;
    });
  });



}