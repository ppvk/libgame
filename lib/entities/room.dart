part of libgame;

// convenience wrapper class.
class Room {

  Room(this._entity);
  Entity _entity;

  DisplayContainerComponent get display => _entity.getComponentByClass(DisplayContainerComponent);

  Bag get actorEntities => (_entity.getComponentByClass(EntityBagComponent) as EntityBagComponent).entities;

  Actor getActorByName(String name) {
    Entity actorEntity = actorEntities.singleWhere((Entity e)
      => (e.getComponentByClass(MetaComponent) as MetaComponent).meta['name'] == name);
    return new Actor(actorEntity);
  }

  List <Actor> getActorsByTag(String tag) {
    List <Entity> entities = actorEntities.where((Entity e)
    => (e.getComponentByClass(MetaComponent) as MetaComponent).meta['tags'].contains(tag));
    List <Actor> actors = [];
    for (Entity e in entities)
      actors.add(new Actor(e));
    return actors;
  }
}