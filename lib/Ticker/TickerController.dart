import 'dart:async';

class TickerController {
  int _ticker;
  final _tickerController = StreamController<int>();

  Stream<int> get tickerStream => _tickerController.stream;
  StreamSink<int> get tickerSink => _tickerController.sink;

//increment stremcontroller
  final _incrementController = StreamController<int>();
  StreamSink<int> get incrementSink => _incrementController.sink;

//decrement stremcontroller
  final _decrementController = StreamController<int>();
  StreamSink<int> get decrementSink => _decrementController.sink;

  TickerController() {
    _ticker = 0;
    _tickerController.add(_ticker);
    _incrementController.stream.listen(_incrementTicker);
    _decrementController.stream.listen(_decrementTicker);
  }

  void _incrementTicker(int ticker) {
    ticker++;
    tickerSink.add(ticker);
  }

  void _decrementTicker(int ticker) {
    ticker--;
    tickerSink.add(ticker);
  }

  void Dispose() {
    _tickerController.close();
    _incrementController.close();
    _decrementController.close();
  }
}
