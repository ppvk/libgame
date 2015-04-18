part of libgame;

/// Used during init() to generate rooms from data files
Future <Entity> createRoom(String roomFile) async {
  // Get the room file
  roomFiles.addTextFile(roomFile,'assets/rooms/$roomFile');
  await roomFiles.load();

  // Decode the room data
  Map roomDef = JSON.decode(roomFiles.getTextFile(roomFile));

  Entity room = world.createEntity()
  ..addComponent(
      new DisplayContainerComponent(
          roomDef['x'],
          roomDef['y'],
          roomDef['width'],
          roomDef['height']
  ));

  // Populate the room's decos
  for (Map deco in roomDef['decos']) {
    Entity decoEntity = await createDeco(
      deco['sprite'],
      deco['flipped'],
      deco['x'],
      deco['y']
    );

    decoEntity.addComponent(new RoomComponent(room));
  }

  // Populate the room's actors.
  Bag <Entity> actors = new Bag();
  for (Map actor in roomDef['actors']) {
    Entity actorEntity =
      await createActor(
          actor['name'],
          actor['tags'],
          actor['actor'],
          actor['x'],
          actor['y'],
          actor['flipped']);

    actorEntity.addComponent(
      new RoomComponent(room)
    );

    actors.add(actorEntity);
  }
  room.addComponent(
    new EntityBagComponent(actors)
  );

  // start disabled
  room.disable();

  rooms[roomFile.split('.').first] = room;
  return room;
}

Room activateRoom(String room) {
  for (Entity room in rooms.values)
    room.disable();
  rooms[room].enable();

  return new Room(rooms[room]);
}