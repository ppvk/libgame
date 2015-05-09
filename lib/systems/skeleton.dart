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
    // Remove the components
    entity.removeComponent(SpriteComponent);
    entity.removeComponent(AnimationComponent);
  }
}



class SkeletonComponent extends Component {
  SkeletonAnimation animation;
  Sprite sprite;
  Rectangle bounds;
  bool _flipped;
  String _layer;

  SkeletonComponent._(String name, this._flipped, this._layer) {
    // Create the Sprite
    sprite = new Sprite();
    _firedAnimationComplete = _firedController.stream;
  }

  String current = 'idle';
  String _idle = 'idle';
  String _fired;
  bool _justFired = false;


  final StreamController _firedController = new StreamController.broadcast();
  Stream _firedAnimationComplete;

  Future fireAnimation(String name) async {
    _fired = name;
    _refresh();
    await _firedAnimationComplete.first;
  }

  setAnimation(String name) {
    _idle = name;
    _refresh();
  }

  _refresh() async {
    if (_fired == null){
      if (_justFired == true) {
        _justFired = false;
        _firedController.add(null);
      }
      animation.state.data.setMixByName(current, _idle, 0.2);
      animation.state
        ..setAnimationByName(0, _idle, false);
      current = _idle;
    }
    else {
      _justFired = true;
      animation.state.data.setMixByName(current, _fired, 0);
      animation.state
        ..setAnimationByName(0, _fired, false);
      current = _fired;
      _fired = null;
    }
  }
}