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
      new ForceComponent());

  // If the definition contains a sprite, generate it and add it to the entity.
  if (actorDef.containsKey('sprite')) {

    Sprite sprite  = new Sprite();
    Map spriteDef = actorDef['sprite'];

    // add the various bitmaps
    for (Map bitmapDef in spriteDef['bitmaps']) {

      // Load the image into memory if needed
      if (!imageFiles.containsBitmapData(bitmapDef['bitmap'])) {
        imageFiles.addBitmapData(bitmapDef['bitmap'], 'assets/images/${bitmapDef['bitmap']}');
        print('loading bitmap ${bitmapDef['bitmap']}');
        await imageFiles.load();
      }

      Bitmap bitmap = new Bitmap(imageFiles.getBitmapData(bitmapDef['bitmap']))
        ..x = bitmapDef['offsetX']
        ..y = bitmapDef['offsetY'];
      sprite.addChild(bitmap);
    }

    // Set the origin of the Sprite
    if (spriteDef.containsKey('originX'))
      sprite.pivotX = spriteDef['originX'];
    if (spriteDef.containsKey('originY'))
      sprite.pivotY = spriteDef['originY'];

    entity.addComponent(new SpriteComponent(sprite, flipped));
  }

  world.addEntity(entity);
  actors[actorDef['name'].split('.').first] = entity;
  return entity;
}