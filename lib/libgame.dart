library libgame;
import 'dart:html';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';

import 'package:stagexl/stagexl.dart';
import 'package:dartemis/dartemis.dart';

export 'package:dartemis/dartemis.dart';

part 'components/generic.dart';
part 'components/controls.dart';
part 'components/rooms.dart';
part 'components/physics.dart';
part 'components/graphics.dart';

part 'generators/room.dart';
part 'generators/actor.dart';

// Entity wrappers for convenience
part 'entities/actor.dart';
part 'entities/room.dart';

World world;
Stage stage;
RenderLoop loop;

ResourceManager roomFiles;
ResourceManager actorFiles;
ResourceManager imageFiles;

Map<String, Entity> actors = {};
Map<String, Entity> rooms = {};

Map keybinds;

init() async {

  // Create and add systems to the world
  world = new World();

  // Creating StageXLs objects;
  ResourceManager resources = new ResourceManager();;
  CanvasElement canvas = querySelector('canvas');

  canvas.context2D.imageSmoothingEnabled = false;

  stage = new Stage(canvas);
  loop = new RenderLoop()
    ..addStage(stage);

  // Different resource managers for different kinds of files
  // (Allows us to have and actor AND a sprite called 'bob.json')
  roomFiles = new ResourceManager();
  actorFiles = new ResourceManager();
  imageFiles = new ResourceManager();

  // load then decode the master definition file
  resources.addTextFile('definitions', 'assets/definition.json');
  await resources.load();
  Map masterDef = JSON.decode(resources.getTextFile('definitions'));


  // Load the key binding data
  keybinds = masterDef['keybinds'];

  // Throw errors if the directory structure is wrong
  if (masterDef['rooms'] == null)  throw("'assets/rooms' directory is missing");
  if (masterDef['actors'] == null)  throw("'assets/actors' directory is missing");
  if (masterDef['images'] == null)  throw("'assets/images' directory is missing");

  // Load all the rooms
  for (String roomFile in masterDef['rooms']) {
    print('creating room $roomFile');
    world.addEntity(
        await createRoom(roomFile)
    );
  }

  // Activate Systems and begin the render loop(s)
  world
    ..addSystem(new MovementSystem())
    ..addSystem(new GravitySystem())
    ..addSystem(new DrawSystem())
    ..addSystem(new RoomSystem())
    ..initialize();
  worldLoop();
}

// A little update loop
worldLoop() async {
  await window.animationFrame;
  world.process();
  world.processEntityChanges();
  loop.advanceTime(world.delta);
  worldLoop();
}