part of libgame;

class MovementSystem extends EntityProcessingSystem {
  Mapper<PositionComponent> positionMapper;
  Mapper<VelocityComponent> velocityMapper;
  Mapper<AccelerationComponent> accelerationMapper;

  MovementSystem() : super(Aspect.getAspectForAllOf(
      [PositionComponent, VelocityComponent, AccelerationComponent]));

  initialize() {
    positionMapper = new Mapper <PositionComponent> (PositionComponent, world);
    velocityMapper = new Mapper <VelocityComponent> (VelocityComponent, world);
    accelerationMapper = new Mapper<AccelerationComponent> (AccelerationComponent, world);
  }

  processEntity(Entity entity) {

    PositionComponent     position = positionMapper[entity];
    VelocityComponent     velocity = velocityMapper[entity];
    AccelerationComponent acceleration = accelerationMapper[entity];

    // update velocity
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;

    // update position
    position.x += velocity.x;
    position.y += velocity.y;
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

// TODO
class MassComponent extends Component {
  num value;
  MassComponent(this.value);
}

// TODO
class ForceComponent extends Component {
  num x;
  num y;
  ForceComponent(this.x, this.y);
}