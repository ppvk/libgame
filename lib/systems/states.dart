part of libgame;


class StateMachine extends Component {
  State currentState;
  State _nextState;
  StateMachine(this.currentState) {
    _nextState = currentState;
  }
  enterState(State state) {
    _nextState = state;
  }
}


class StateSystem extends EntityProcessingSystem {
  Mapper<StateMachine> stateMachineMapper;

  StateSystem() : super(Aspect.getAspectForAllOf([StateMachine]));

  initialize() {
    stateMachineMapper = new Mapper<StateMachine> (StateMachine, world);
  }

  processEntity(Entity entity) {
    StateMachine state = stateMachineMapper[entity];
    if (state._nextState != state.currentState) {
      state.currentState.exit(entity);
      state._nextState.enter(entity);
      state.currentState = state._nextState;
    }
    state.currentState.handleInput(entity);
    state.currentState.update(entity);
  }
}


class State {
  enter(Entity entity) {}
  exit(Entity entity) {}
  handleInput(Entity entity) {}
  update(Entity entity) {}

  goTo(Entity entity, State other) {
    StateMachine stateMachine = entity.getComponentByClass(StateMachine);
    stateMachine.enterState(other);
  }
}


