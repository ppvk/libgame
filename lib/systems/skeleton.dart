part of libgame;


class SkeletonSystem extends EntityProcessingSystem {
  Mapper<SkeletonComponent> skeletonMapper;

  SkeletonSystem() : super(Aspect.getAspectForAllOf([SkeletonComponent]));

  initialize() {
    skeletonMapper = new Mapper <SkeletonComponent> (SkeletonComponent, world);
  }

  processEntity(Entity entity) {
    SkeletonComponent   skeletonComponent = skeletonMapper[entity];

    if (entity.getComponentByClass(SpriteComponent) == null && skeletonComponent.sprite != null)
      entity.addComponent(
          new SpriteComponent(
              skeletonComponent.sprite,
              skeletonComponent._flipped,
              skeletonComponent._layer));
    if (entity.getComponentByClass(AnimationComponent) == null && skeletonComponent.animation != null)
      entity.addComponent(
          new AnimationComponent(
              skeletonComponent.animation));

  }

  removed(Entity entity) {
    SkeletonComponent  skeletonComponent = skeletonMapper[entity];

    // Remove the components
    entity.removeComponent(SpriteComponent);
    entity.removeComponent(AnimationComponent);
  }
}