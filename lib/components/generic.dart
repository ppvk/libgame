part of libgame;

/// Signifies that an entity is 'active'
class ActiveComponent extends Component {
  ActiveComponent();
}

class MetaComponent extends Component {
  Map meta;
  MetaComponent() {
    this.meta = {};
  }
}