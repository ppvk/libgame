part of libgame;

Future <SpriteComponent> createDecoSprite(Map decoDef) async {
  Sprite sprite  = new Sprite();
  for (Map bitmapDef in decoDef['bitmaps']) {

    // Load the image into memory if needed
    if (!RESOURCES.containsBitmapData(bitmapDef['src'])) {
      RESOURCES.addBitmapData(bitmapDef['src'], 'assets/images/${bitmapDef['src']}');
      print('loading bitmap ${bitmapDef['src']}');
    }
    await RESOURCES.load();

    Bitmap bitmap = new Bitmap(RESOURCES.getBitmapData(bitmapDef['src']))
      ..x = bitmapDef['offsetX']
      ..y = bitmapDef['offsetY'];
    sprite.addChild(bitmap);
  }

  // Set the origin of the Sprite
  if (decoDef.containsKey('originX'))
  sprite.pivotX = decoDef['originX'];
  if (decoDef.containsKey('originY'))
  sprite.pivotY = decoDef['originY'];

  // Create the SpriteComponent
  return new SpriteComponent(sprite, decoDef['flipped'], decoDef['layer']);
}