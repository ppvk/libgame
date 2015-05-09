part of libgame;

// This system draws sprites to the screen when their room is active..
class AnimationSystem extends EntityProcessingSystem {
  Mapper<AnimationComponent> animationMapper;

  AnimationSystem() : super(Aspect.getAspectForAllOf([AnimationComponent]));

  initialize() {
    animationMapper = new Mapper <AnimationComponent> (AnimationComponent, world);
  }

  processEntity(Entity entity) {
    AnimationComponent   animationComponent = animationMapper[entity];

    // Add the Sprite to the entity's room, if not there already.
    if (!STAGE.juggler.contains(animationComponent.animation))
      STAGE.juggler.add(animationComponent.animation);
  }

  removed(Entity entity) {
    AnimationComponent  animationComponent = animationMapper[entity];
    // Remove the sprite from the room.

    if (STAGE.juggler.contains(animationComponent.animation))
      STAGE.juggler.remove(animationComponent.animation);
  }
}

class AnimationComponent extends Component {
  Animatable animation;
  AnimationComponent(this.animation);
}