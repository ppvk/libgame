part of libgame;


class SpriteSystem extends EntityProcessingSystem {
  Mapper<PositionComponent> positionMapper;
  Mapper<SpriteComponent> spriteMapper;
  Mapper<RoomComponent> roomMapper;

  SpriteSystem() : super(Aspect.getAspectForAllOf([PositionComponent, SpriteComponent, RoomComponent]));

  initialize() {
    positionMapper = new Mapper <PositionComponent> (PositionComponent, world);
    spriteMapper = new Mapper <SpriteComponent> (SpriteComponent, world);
    roomMapper = new Mapper <RoomComponent> (RoomComponent, world);
  }

  processEntity(Entity entity) {

    PositionComponent   positionComponent = positionMapper[entity];
    SpriteComponent     spriteComponent = spriteMapper[entity];
    RoomComponent       roomComponent = roomMapper[entity];

    // Add the Sprite to the entity's room, if not there already.
    DisplayContainerComponent roomDisplay =
      roomComponent.room.getComponentByClass(DisplayContainerComponent);
    if (!roomDisplay.display.contains(spriteComponent.sprite)) {
      roomDisplay.display.addChild(spriteComponent.sprite);
      print('sprite added to room');
    }

    EntityBagComponent roomEntityBag =
      roomComponent.room.getComponentByClass(EntityBagComponent);
    if (!roomEntityBag.entities.contains(entity))
      roomEntityBag.entities.add(entity);

    // Update the sprite's position
    if (spriteComponent.sprite.x != positionComponent.x)
      spriteComponent.sprite.x = positionComponent.x;
    if (spriteComponent.sprite.y != positionComponent.y)
      spriteComponent.sprite.y = positionComponent.y;

    // Update the sprite's direction
    if (spriteComponent.flipped == true)
      spriteComponent.sprite.scaleX = -1;
    else
      spriteComponent.sprite.scaleX = 1;

  }

  removed(Entity entity) {
    SpriteComponent     spriteComponent = spriteMapper[entity];
    RoomComponent       roomComponent = roomMapper[entity];

    // Remove the sprite from the room.
    DisplayContainerComponent roomDisplay =
      roomComponent.room.getComponentByClass(DisplayContainerComponent);
    roomDisplay.display.removeChild(spriteComponent.sprite);

    EntityBagComponent roomEntityBag =
      roomComponent.room.getComponentByClass(EntityBagComponent);
    roomEntityBag.entities.remove(entity);
  }
}

class SpriteComponent extends Component {
  Sprite sprite;
  bool flipped;
  SpriteComponent(this.sprite, this.flipped);
}

class RoomComponent extends Component {
  Entity room;
  RoomComponent(this.room);
}