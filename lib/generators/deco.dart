part of libgame;

Future <Entity> createDeco(String file, bool flipped, num x, num y) async {
  Entity entity = world.createEntity();

  entity.addComponent(new PositionComponent(x,y));

  SpriteComponent sprite = await createSprite(file, flipped);
  entity.addComponent(sprite);
  return entity;
}