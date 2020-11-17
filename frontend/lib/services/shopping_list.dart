import 'dart:async';

StreamController<void> _controller =
    StreamController<void>.broadcast(sync: true);

StreamSubscription<void> subscribeToGroceryDidChange(void Function() callback) {
  return _controller.stream.listen((_) => callback());
}

void emitGroceryDidChange() {
  _controller.add(null);
}
