part of libgame;


/// System that updates position based on velocity
class VelocitySystem extends EntityProcessingSystem {
  Mapper<VelocityComponent> velocityMapper;
  Mapper<PositionComponent> positionMapper;

  VelocitySystem() : super(Aspect.getAspectForAllOf(
      [PositionComponent, VelocityComponent]));

  initialize() {
    positionMapper = new Mapper <PositionComponent> (PositionComponent, world);
    velocityMapper = new Mapper <VelocityComponent> (VelocityComponent, world);
  }

  processEntity(Entity entity) {
    PositionComponent     position = positionMapper[entity];
    VelocityComponent     velocity = velocityMapper[entity];

    // update position
    position.x += velocity.x;
    position.y += velocity.y;
  }
}


/// System that updates velocity based on acceleration
class AccelerationSystem extends EntityProcessingSystem {
  Mapper<VelocityComponent> velocityMapper;
  Mapper<AccelerationComponent> accelerationMapper;

  AccelerationSystem() : super(Aspect.getAspectForAllOf(
      [VelocityComponent, AccelerationComponent]));

  initialize() {
    velocityMapper = new Mapper <VelocityComponent> (VelocityComponent, world);
    accelerationMapper = new Mapper<AccelerationComponent> (AccelerationComponent, world);
  }

  processEntity(Entity entity) {
    VelocityComponent     velocity = velocityMapper[entity];
    AccelerationComponent acceleration = accelerationMapper[entity];

    // update velocity
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
  }
}




class PositionComponent extends Component {
  num x;
  num y;
  PositionComponent(this.x, this.y);
}

class VelocityComponent extends Component {
  num x;
  num y;
  VelocityComponent(this.x, this.y);
}

class AccelerationComponent extends Component {
  num x;
  num y;
  AccelerationComponent(this.x, this.y);
}