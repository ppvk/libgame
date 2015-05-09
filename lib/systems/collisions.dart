part of libgame;


class CollisionSystem extends EntityProcessingSystem {
  Mapper<SpriteComponent> spriteMapper;
  Mapper<CollisionComponent> collisionMapper;

  List collideableEntities = [];

  CollisionSystem() : super(Aspect.getAspectForAllOf([CollisionComponent, SpriteComponent]));

  initialize() {
    spriteMapper = new Mapper<SpriteComponent> (SpriteComponent, world);
    collisionMapper = new Mapper<CollisionComponent> (CollisionComponent, world);
  }

  processEntity(Entity entity) {
    SpriteComponent sprite = spriteMapper[entity];
    CollisionComponent collision = collisionMapper[entity];

    // Updates the collide-able list.
    if (!collideableEntities.contains(entity)) {
      collideableEntities.add(entity);
    }

    // Delete non-collideable entities from the collision component
    for (Entity otherEntity in new List.from(collision._collisions)) {
      if (!collideableEntities.contains(otherEntity))
        collision._collisions.remove(otherEntity);
    }

    // Check to see if there are any collisions
    for (Entity otherEntity in collideableEntities.where((e) => e != entity)) {

      Sprite otherSprite = (otherEntity.getComponentByClass(SpriteComponent)
        as SpriteComponent).sprite;


      // Skeletons need a workaround to get their bounding boxes.
      Rectangle bounds;
      if (entity.getComponentByClass(SkeletonComponent) != null) {
        SkeletonComponent skeleton = entity.getComponentByClass(SkeletonComponent);
        bounds = new Rectangle(
            sprite.sprite.x + skeleton.bounds.left,
            sprite.sprite.y + skeleton.bounds.top,
            skeleton.bounds.width,
            skeleton.bounds.height
        );
      }
      else {
        bounds = sprite.sprite.boundsTransformed;
      }

      Rectangle otherBounds;
      if (otherEntity.getComponentByClass(SkeletonComponent) != null) {
        SkeletonComponent skeleton = otherEntity.getComponentByClass(SkeletonComponent);
        otherBounds = new Rectangle(
            otherSprite.x + skeleton.bounds.left,
            otherSprite.y + skeleton.bounds.top,
            skeleton.bounds.width,
            skeleton.bounds.height
        );
      }
      else {
        otherBounds = otherSprite.boundsTransformed;
      }

      // Check for collision
      bool collides = bounds.intersects(otherBounds);

      // Update the 'currently colliding' list
      if (collides) {
        if (!collision._collisions.contains(otherEntity))
          collision._collisions.add(otherEntity);
      }
      else {
        if (collision._collisions.contains(otherEntity))
          collision._collisions.remove(otherEntity);
      }

    }

  }

  removed(Entity entity) {
    if (collideableEntities.contains(entity)) {
      collideableEntities.remove(entity);
    }
  }
}


class CollisionComponent extends Component {
  CollisionComponent() {
    this._collisions = [];
  }
  List <Entity> _collisions;

  bool withEntity(Entity other) {
    return _collisions.contains(other);
  }
}