part of libgame;

// convenience wrapper class.
class Actor {

  Actor(this._entity) {
    print('constructed');
  }
  Entity _entity;

  PositionComponent get position => _entity.getComponentByClass(PositionComponent);
  VelocityComponent get velocity => _entity.getComponentByClass(VelocityComponent);
  AccelerationComponent get acceleration => _entity.getComponentByClass(AccelerationComponent);
  ForceComponent get force => _entity.getComponentByClass(ForceComponent);
  MassComponent get mass => _entity.getComponentByClass(MassComponent);
  SpriteComponent get sprite => _entity.getComponentByClass(SpriteComponent);
}