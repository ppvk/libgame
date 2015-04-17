part of libgame;

class GravitySystem extends EntityProcessingSystem {
  Mapper<ForceComponent> forceMapper;
  Mapper<MassComponent> massMapper;

  GravitySystem() : super(Aspect.getAspectForAllOf(
      [ForceComponent, MassComponent]));

  initialize() {
    forceMapper = new Mapper<ForceComponent> (ForceComponent, world);
  }

  processEntity(Entity entity) {
    ForceComponent force = forceMapper[entity];
    force.y += 0.1;
  }
}



class MovementSystem extends EntityProcessingSystem {
  Mapper<PositionComponent> positionMapper;
  Mapper<VelocityComponent> velocityMapper;
  Mapper<AccelerationComponent> accelerationMapper;
  Mapper<ForceComponent> forceMapper;
  Mapper<MassComponent> massMapper;

  MovementSystem() : super(Aspect.getAspectForAllOf(
      [PositionComponent, VelocityComponent, AccelerationComponent, ForceComponent, MassComponent]));


  initialize() {
    positionMapper = new Mapper <PositionComponent> (PositionComponent, world);
    velocityMapper = new Mapper <VelocityComponent> (VelocityComponent, world);
    accelerationMapper = new Mapper<AccelerationComponent> (AccelerationComponent, world);
    forceMapper = new Mapper<ForceComponent> (ForceComponent, world);
    massMapper = new Mapper<MassComponent> (MassComponent, world);
  }

  processEntity(Entity entity) {
    PositionComponent     position = positionMapper[entity];
    VelocityComponent     velocity = velocityMapper[entity];
    AccelerationComponent acceleration = accelerationMapper[entity];
    ForceComponent force = forceMapper[entity];
    MassComponent mass = massMapper[entity];

    // update acceleration
    acceleration.x += force.x / mass.value;
    acceleration.y += force.y / mass.value;

    // update velocity
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;

    // update position
    position.x += velocity.x;
    position.y += velocity.y;


    if (position.y > 600) {
      position.y = 600;
      velocity.y = 0;
      acceleration.y = 0;
      force.y = 0;
    }

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

class MassComponent extends Component {
  num value;
  MassComponent(this.value);
}

class ForceComponent extends Component {
  num x;
  num y;
  ForceComponent(this.x, this.y);
}