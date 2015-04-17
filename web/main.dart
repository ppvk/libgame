import 'package:libgame/libgame.dart';
import 'dart:async';
import 'dart:html';

main() async {
  await init();

  print(keybinds);

  Room room1 = activateRoom('room1');

  List <Actor> bunnies = room1.getActorsByTag('bunny');


  document.onKeyUp.listen((event) {
    bunnies.forEach((Actor bunny) {
      bunny.velocity.y -= 10;
    });
  });



}