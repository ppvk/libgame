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
    //force.y += 0.1;
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
    acceleration.x += force.calculatedX / mass.value;
    acceleration.y += force.calculatedY / mass.value;

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

class MassComponent extends Component {
  num value;
  MassComponent(this.value);
}

class ForceComponent extends Component {
  List<Force> forces;

  // calculates the total of x forces
  get calculatedX {
    num x = 0;
    for (Force force in forces)
      x += force.x;
    return x;
  }
  // calculates the total of the y forces
  get calculatedY {
    num y = 0;
    for (Force force in forces)
      y += force.y;
    return y;
  }

  ForceComponent() {
    this.forces = [];
  }

  impulse(num angle, num force, num duration) {
    num x = force * math.cos(angle);
    num y = force * math.sin(angle);

    Force newForce = new Force(x,y);
    forces.add(newForce);

    new Timer(new Duration (milliseconds: duration), () {
      forces.remove(newForce);
    });
  }
}
// Data-holding abstraction of a force.
class Force {
  num x;
  num y;
  Force(this.x, this.y);
}