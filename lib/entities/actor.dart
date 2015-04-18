part of libgame;

// convenience wrapper class.
class Actor {

  Actor(this.entity);
  Entity entity;

  PositionComponent get position => entity.getComponentByClass(PositionComponent);
  VelocityComponent get velocity => entity.getComponentByClass(VelocityComponent);
  AccelerationComponent get acceleration => entity.getComponentByClass(AccelerationComponent);
  ForceComponent get force => entity.getComponentByClass(ForceComponent);
  MassComponent get mass => entity.getComponentByClass(MassComponent);
  SpriteComponent get sprite => entity.getComponentByClass(SpriteComponent);
}