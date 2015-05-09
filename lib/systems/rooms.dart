part of libgame;

class RoomSystem extends EntityProcessingSystem {
  Mapper<RoomComponent> roomMapper;

  RoomSystem() : super(Aspect.getAspectForAllOf([RoomComponent]));

  initialize() {
    roomMapper = new Mapper <RoomComponent> (RoomComponent, world);
  }

  processEntity(Entity entity) {
    RoomComponent roomComponent = roomMapper[entity];

    // activate containing entities
    for (Entity actor in roomComponent.entities) {
      actor.enable();
    }

    // Add the Room to the Stage, if not there already.
    if (!STAGE.contains(roomComponent._display)) {
      STAGE.addChild(roomComponent._display);
    }


    // Update the displayComponent's position
    if (roomComponent._display.x != -roomComponent.x)
      roomComponent._display.x = -roomComponent.x;
    if (roomComponent._display.y != -roomComponent.y)
      roomComponent._display.y = -roomComponent.y;
  }

  removed(Entity entity) {
    RoomComponent roomComponent = roomMapper[entity];

    // deactivate containing entities
    for (Entity actor in roomComponent.entities) {
      actor.disable();
    }

    // Remove the room from the Stage.
    if (STAGE.contains(roomComponent._display)) {
      STAGE.removeChild(roomComponent._display);
    }
  }
}

/// The room's entity container, holds visible entities
class RoomComponent extends Component {
  List <Entity> entities;
  Sprite _display;
  Sprite foreground;
  Sprite middleground;
  Sprite background;


  num x;
  num y;
  num width;
  num height;

  RoomComponent(this.entities, this.x, this.y, this.width, this.height) {
    this._display = new Sprite()
      ..width = width
      ..height = height;

    this.foreground = new Sprite();
    this.middleground = new Sprite();
    this.background = new Sprite();

    _display
      ..addChild(background)
      ..addChild(middleground)
      ..addChild(foreground);

  }

  List getActorsByTag(String tag) {
    List returned = new List();

    for (Entity entity in entities) {
      MetaComponent meta = entity.getComponentByClass(MetaComponent);
      if (meta != null) {
        if (meta.meta['tags'].contains(tag))
          returned.add(entity);
      }
    }
    return returned;
  }

  Entity getActorByName(String name) {

    for (Entity entity in entities) {
      MetaComponent meta = entity.getComponentByClass(MetaComponent);
      if (meta != null) {
        print(meta.meta);

        if (meta.meta['name'] == name)
          return entity;
      }
    }
    throw('Entity $name not found.');
    return null;
  }
}