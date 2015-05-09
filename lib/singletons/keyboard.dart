part of libgame;


Keyboard keyboard = new Keyboard._();

class Keyboard {
  List <num> _pressedKeys = [];
  Keyboard._() {
    document.onKeyDown.listen((event) async {
      _pressedKeys.add(event.keyCode);
      await document.onKeyUp.firstWhere((event2) => event2.keyCode == event.keyCode);
      _pressedKeys.remove(event.keyCode);
    });
  }

  simulatePress(String key) {
    _pressedKeys.add(_keybinds[key]);
  }
  simulateRelease(String key) {
    _pressedKeys.remove(_keybinds[key]);
  }

  bool keyIsPressed(String key) => _pressedKeys.contains(_keybinds[key]);
}