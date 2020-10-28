
import 'dart:typed_data';

class FnState {
  static const int SHIFT_OPENED_OFFSET = 0;

  bool _shiftOpened;

  FnState(Uint8List data, int offset, int size) {
    _shiftOpened = (data[offset + SHIFT_OPENED_OFFSET] != 0);
  }

  bool isShiftOpened() => _shiftOpened;

  @override
  String toString() => '{\n  shiftOpened: $_shiftOpened\n}';
}
