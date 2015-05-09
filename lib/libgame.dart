library libgame;
import 'dart:html' hide Rectangle, Point;
import 'dart:convert';
import 'dart:async';

import 'package:stagexl/stagexl.dart';
import 'package:stagexl_spine/stagexl_spine.dart';
import 'package:dartemis/dartemis.dart';

export 'package:dartemis/dartemis.dart';
export 'package:stagexl/stagexl.dart';

part 'systems/generic.dart';
part 'singletons/keyboard.dart';
part 'systems/collisions.dart';
part 'systems/states.dart';
part 'systems/camera.dart';
part 'systems/rooms.dart';
part 'systems/physics.dart';
part 'systems/sprite.dart';
part 'systems/animation.dart';
part 'systems/skeleton.dart';

part 'generators/room.dart';
part 'generators/actor.dart';
part 'generators/skeleton.dart';
part 'generators/deco.dart';

World WORLD;
Stage STAGE;
ResourceManager RESOURCES;
CanvasElement CANVAS;
RenderLoop LOOP;


Map<String, Entity> actors = {};
Map<String, Entity> rooms = {};

Map _keybinds;
List <Function> _gameLoopExtras = [];

init(CanvasElement canvas) async {

  WORLD = new World();
  RESOURCES = new ResourceManager();
  CANVAS = canvas;

  STAGE = new Stage(CANVAS, width: 1024, height: 768)
    ..scaleMode = StageScaleMode.NO_BORDER
    ..align = StageAlign.NONE;

  LOOP = new RenderLoop()
    ..addStage(STAGE);

  // load then decode the master definition file
  RESOURCES.addTextFile('definitions', 'assets/definition.json');
  await RESOURCES.load();
  Map masterDef = JSON.decode(RESOURCES.getTextFile('definitions'));

  // Load the key binding data
  _keybinds = masterDef['keybinds'];

  // Load all the rooms
  for (String room in masterDef['rooms'].keys) {
    WORLD.addEntity(
        await createRoom(room, masterDef['rooms'][room])
    );
  }

  // Activate Systems and begin the render loop(s)
  WORLD
    ..addSystem(new CameraSystem())
    ..addSystem(new StateSystem())
    ..addSystem(new CollisionSystem())

    ..addSystem(new VelocitySystem())
    ..addSystem(new AccelerationSystem())

    ..addSystem(new SkeletonSystem())
    ..addSystem(new DrawSystem())
    ..addSystem(new AnimationSystem())

    ..addSystem(new RoomSystem())
    ..initialize();
  worldLoop();
}

// A little update loop
worldLoop() async {
  await wait(new Duration(milliseconds: 15));

  WORLD.process();

  for (Function f in _gameLoopExtras)
    f();
  worldLoop();

}

/// adds a function to the game loop.
/// use sparingly.
addToGameLoop(Function f) => _gameLoopExtras.add(f);



/// A future that returns after a duration
Future wait(Duration duration) {
  Completer completer = new Completer();
  new Timer(duration, () => completer.complete());
  return completer.future;
}