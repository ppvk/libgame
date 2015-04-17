part of libgame;

// Assembles Actors for Rooms
Future <Entity> createActor(
    String name,
    List<String> tags,
    String actorFile,
    num x, num y,
    bool flipped) async {

  // Load the file into memory if needed
  if (!actorFiles.containsTextFile(actorFile)) {
    actorFiles.addTextFile(actorFile,'assets/actors/$actorFile');
    print('loading actor $actorFile');
    await actorFiles.load();
  }

  // Decode the actor data
  Map actorDef = JSON.decode(actorFiles.getTextFile(actorFile));

  Entity entity = world.createEntity();

  print('Setting components for Actor');
  // Set the entities position
  entity
    ..addComponent(
      new MetaComponent()
      ..meta['name'] = name
      ..meta['tags'] = tags)
    ..addComponent(
      new MassComponent(actorDef['mass']))
    ..addComponent(
      new PositionComponent(x, y))
    ..addComponent(
      new VelocityComponent(0,0))
    ..addComponent(
      new AccelerationComponent(0,0))
    ..addComponent(
      new ForceComponent(0,0));

  // If the definition contains a sprite, generate it and add it to the entity.
  if (actorDef.containsKey('sprite')) {
    SpriteComponent sprite = await createSprite(actorDef['sprite'], flipped);
    entity.addComponent(sprite);
  }

  world.addEntity(entity);
  actors[actorDef['name'].split('.').first] = entity;
  return entity;
}