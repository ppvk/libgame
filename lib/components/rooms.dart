part of libgame;

class RoomSystem extends EntityProcessingSystem {
  Mapper<DisplayContainerComponent> displayMapper;
  Mapper<EntityBagComponent> entityBagMapper;

  RoomSystem() : super(Aspect.getAspectForAllOf([DisplayContainerComponent, EntityBagComponent]));

  initialize() {
    displayMapper = new Mapper <DisplayContainerComponent> (DisplayContainerComponent, world);
    entityBagMapper = new Mapper <EntityBagComponent> (EntityBagComponent, world);
  }

  processEntity(Entity entity) {
    DisplayContainerComponent displayComponent = displayMapper[entity];
    EntityBagComponent entityBagComponent = entityBagMapper[entity];

    // activate containing entities
    for (Entity actor in entityBagComponent.entities) {
      if (!actor.active)
      actor.enable();
    }

    // Add the Room to the Stage, if not there already.
    if (!stage.contains(displayComponent.display)) {
      stage.addChild(displayComponent.display);
      print('room added to stage');
    }


    // Update the displayComponent's position
    if (displayComponent.display.x != -displayComponent.x)
      displayComponent.display.x = -displayComponent.x;
    if (displayComponent.display.y != -displayComponent.y)
      displayComponent.display.y = -displayComponent.y;
  }

  removed(Entity entity) {
    DisplayContainerComponent displayComponent = displayMapper[entity];
    EntityBagComponent entityBagComponent = entityBagMapper[entity];

    // deactivate containing entities
    for (Entity actor in entityBagComponent.entities) {
      if (actor.active)
        actor.disable();
    }

    print('deactivated room');
    // Remove the room from the Stage.
    if (stage.contains(displayComponent.display)) {
      stage.removeChild(displayComponent.display);
    }
  }
}

/// The room's entity container, holds actor entities
class EntityBagComponent extends Component {
  Bag <Entity> entities;
  EntityBagComponent(this.entities);
}

/// The room's display container, holds actor sprites
class DisplayContainerComponent extends Component {
  Sprite display;
  num x;
  num y;
  DisplayContainerComponent(this.x, this.y, width, height) {
   this.display = new Sprite()
    ..width = width
    ..height = height;
  }
}