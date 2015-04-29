part of libgame;

class CameraFocus extends Component {
  CameraFocus();
}

class CameraSystem extends EntityProcessingSystem {
  Mapper<PositionComponent> positionMapper;

  CameraSystem() : super(Aspect.getAspectForAllOf([CameraFocus, PositionComponent]));

  initialize() {
    positionMapper = new Mapper<PositionComponent> (PositionComponent, world);
  }

  processEntity(Entity entity) {
    PositionComponent position = positionMapper[entity];
    RoomComponent display = ACTIVE_ROOM.getComponentByClass(RoomComponent);

    display.x = position.x - (STAGE.contentRectangle.width/2);

    if (display.x < 0)
      display.x = 0;
    if (display.x > display.width - STAGE.contentRectangle.width)
      display.x = display.width - STAGE.contentRectangle.width;
  }
}