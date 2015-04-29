part of libgame;

Future <SkeletonComponent> createSkeleton(String name, bool flipped, String layer) async {
  SkeletonComponent skeleton = new SkeletonComponent._(name, flipped, layer);

  // We append '_SKELETON' to the name to avoid conflicts with similarly named json files
  if (!RESOURCES.containsTextureAtlas(name + '_SKELETON')) {
    RESOURCES.addTextFile(
        name + '_SKELETON', 'assets/skeleton/' + name + '/skeleton.json');
    RESOURCES.addTextureAtlas(
        name + '_SKELETON', 'assets/skeleton/' + name + '/skeleton.atlas', TextureAtlasFormat.LIBGDX);
  }
  await RESOURCES.load();

  // Build the skeleton
  var skeletonJson = RESOURCES.getTextFile(name + '_SKELETON');
  var textureAtlas = RESOURCES.getTextureAtlas(name + '_SKELETON');
  var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
  var skeletonLoader = new SkeletonLoader(attachmentLoader);
  var skeletonData = skeletonLoader.readSkeletonData(skeletonJson);
  var animationStateData = new AnimationStateData(skeletonData);
  skeleton.animation = new SkeletonAnimation(skeletonData, animationStateData);

  skeleton.setAnimation('idle');
  skeleton.sprite.addChild(skeleton.animation);

  return skeleton;
}











class SkeletonComponent extends Component {
  SkeletonAnimation animation;
  Sprite sprite;
  String _currentAnimation;
  bool _flipped;
  String _layer;

  SkeletonComponent._(String name, this._flipped, this._layer) {
    // Create the Sprite
    sprite = new Sprite();
  }

  Future fireAnimation(String name) async {
    if (_currentAnimation == name)
      return new Future(() => print('already active'));
    animation.state.setAnimationByName(0, name, false);
    _currentAnimation = name;
    return await animation.state.onTrackComplete.first;
  }

  setAnimation(String name) async {
    if (_currentAnimation != name) {
    animation.state.setAnimationByName(0, name, true);
    _currentAnimation = name;
    }
  }
}