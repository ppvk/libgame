part of libgame;



/// Used during init() to generate rooms from data files
Future <Entity> createRoom(String roomName, Map roomDef) async {

  //Create an empty entity
  Entity room = WORLD.createEntity();

  List <Entity> roomEntities = [];

  // Populate the rooms decos
  for (Map deco in roomDef['decos']) {
    Entity decoEntity = WORLD.createEntity()
      ..addComponent(await createDecoSprite(deco))
      ..addComponent(new PositionComponent(deco['x'], deco['y']))
      ..addComponent(new CurrentRoomComponent(room));

    roomEntities.add(decoEntity);
  }

  // Populate the room's actors.
  for (Map actor in roomDef['actors']) {
    Entity actorEntity =
      await createActor(actor);

    actorEntity.addComponent(
      new CurrentRoomComponent(room)
    );
    roomEntities.add(actorEntity);
  }

  room.addComponent(
    new RoomComponent(
        roomEntities,
        roomDef['x'],
        roomDef['y'],
        roomDef['width'],
        roomDef['height']
    ));

  // start disabled
  room.disable();

  // catalog the room with its filename as a key
  rooms[roomName] = room;
  return room;
}


Entity _activeRoom;
Entity get ACTIVE_ROOM => _activeRoom;
Entity activateRoom(String room) {
  for (Entity room in rooms.values)
    room.disable();
  rooms[room].enable();
  _activeRoom = rooms[room];
  rooms[room];
}