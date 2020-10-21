import 'dart:typed_data';

import 'package:local_fiscal_service/utils/uint8list_extension.dart';

extension ListSwap<T> on List<T> {
  List<T> swap(int index1, int index2) {
    var length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
    return this;
  }

  int toInt() {
    List<int> castList = this.cast<int>();
    Uint8List bytes = Uint8List.fromList(castList);
    return bytes.toInt();
  }
}