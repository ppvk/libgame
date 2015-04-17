part of libgame;

// Assembles SpriteComponents for Actors
Future <SpriteComponent> createSprite(String spriteFile, bool flipped) async {

  // Load the file into memory if needed
  if (!spriteFiles.containsTextFile(spriteFile)) {
    spriteFiles.addTextFile(spriteFile, 'assets/sprites/$spriteFile');
    await spriteFiles.load();
  }

  // Decode the sprite data
  Map spriteDef = JSON.decode(spriteFiles.getTextFile(spriteFile));

  Sprite sprite  = new Sprite();

  // add the various bitmaps
  for (Map bitmapDef in spriteDef['bitmaps']) {

    // Load the file into memory if needed
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

  return new SpriteComponent(sprite, flipped);
}