part of libgame;

// convenience wrapper class.
class Actor {

  Actor(this.entity);
  Entity entity;


  bool hasTag(String tag) {
    MetaComponent meta = entity.getComponentByClass(MetaComponent);
    return meta.meta['tags'].contains(tag);
  }

  PositionComponent get position => entity.getComponentByClass(PositionComponent);
  VelocityComponent get velocity => entity.getComponentByClass(VelocityComponent);
  AccelerationComponent get acceleration => entity.getComponentByClass(AccelerationComponent);
  ForceComponent get force => entity.getComponentByClass(ForceComponent);
  MassComponent get mass => entity.getComponentByClass(MassComponent);
  SpriteComponent get sprite => entity.getComponentByClass(SpriteComponent);
}