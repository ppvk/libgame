part of libgame;

// Assembles Actors for Rooms
Future <Entity> createActor(Map actorDef) async {

  Entity entity = WORLD.createEntity();

  entity
    ..addComponent(
      new MetaComponent()
      ..meta['name'] = actorDef['name']
      ..meta['tags'] = actorDef['tags'])

    ..addComponent(
      new PositionComponent(actorDef['x'], actorDef['y']))

    ..addComponent(
      new VelocityComponent(0,0))

    ..addComponent(
      new AccelerationComponent(0,0))

    ..addComponent(
      await createSkeleton(
          actorDef['skeleton'],
          actorDef['flipped'],
          actorDef['layer']));

  actors[actorDef['name']] = entity;
  return entity;
}


class SpriteComponent extends Component {
  Sprite sprite;
  bool flipped;
  String layer;
  SpriteComponent(this.sprite, this.flipped, this.layer);
}

class CurrentRoomComponent extends Component {
  Entity room;
  CurrentRoomComponent(this.room);
}