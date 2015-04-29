part of libgame;


Keyboard keyboard = new Keyboard._();


class PlayerControl extends Component {
  PlayerControl();
}

class Keyboard {
  List <num> _pressedKeys = [];
  Keyboard._() {
    StreamSubscription keyListener = document.onKeyDown.listen((event) async {
      _pressedKeys.add(event.keyCode);
      await document.onKeyUp.firstWhere((event2) => event2.keyCode == event.keyCode);
      _pressedKeys.remove(event.keyCode);
    });
  }

  bool keyIsPressed(String key) => _pressedKeys.contains(_keybinds[key]);
}