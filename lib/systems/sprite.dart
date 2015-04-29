part of libgame;

// This system draws sprites to the screen when their room is active..
class DrawSystem extends EntityProcessingSystem {
  Mapper<PositionComponent> positionMapper;
  Mapper<SpriteComponent> spriteMapper;
  Mapper<CurrentRoomComponent> roomMapper;

  DrawSystem() : super(Aspect.getAspectForAllOf([PositionComponent, SpriteComponent, CurrentRoomComponent]));

  initialize() {
    positionMapper = new Mapper <PositionComponent> (PositionComponent, world);
    spriteMapper = new Mapper <SpriteComponent> (SpriteComponent, world);
    roomMapper = new Mapper <CurrentRoomComponent> (CurrentRoomComponent, world);
  }

  processEntity(Entity entity) {

    PositionComponent   positionComponent = positionMapper[entity];
    SpriteComponent     spriteComponent = spriteMapper[entity];
    CurrentRoomComponent       roomComponent = roomMapper[entity];

    // Add the Sprite to the entity's room, if not there already.
    RoomComponent roomDisplay =
      roomComponent.room.getComponentByClass(RoomComponent);


    if (!roomDisplay.foreground.contains(spriteComponent.sprite) && spriteComponent.layer == 'foreground') {
      roomDisplay.foreground.addChild(spriteComponent.sprite);
    }

    if (!roomDisplay.middleground.contains(spriteComponent.sprite) && spriteComponent.layer == 'middleground') {
      roomDisplay.middleground.addChild(spriteComponent.sprite);
    }

    if (!roomDisplay.background.contains(spriteComponent.sprite) && spriteComponent.layer == 'background') {
      roomDisplay.background.addChild(spriteComponent.sprite);
    }

    RoomComponent roomEntityBag =
      roomComponent.room.getComponentByClass(RoomComponent);
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
    CurrentRoomComponent roomComponent = roomMapper[entity];

    // Remove the sprite from the room.
    RoomComponent roomDisplay =
      roomComponent.room.getComponentByClass(RoomComponent);

    if (roomDisplay.foreground.contains(spriteComponent.sprite)) {
      roomDisplay.foreground.removeChild(spriteComponent.sprite);
    }

    if (roomDisplay.middleground.contains(spriteComponent.sprite)) {
      roomDisplay.middleground.removeChild(spriteComponent.sprite);
    }

    if (roomDisplay.background.contains(spriteComponent.sprite)) {
      roomDisplay.background.removeChild(spriteComponent.sprite);
    }

    RoomComponent roomEntityBag =
      roomComponent.room.getComponentByClass(RoomComponent);
    roomEntityBag.entities.remove(entity);
  }
}