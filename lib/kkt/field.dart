import 'dart:typed_data';

import 'package:local_fiscal_service/exceptions/unknown_tag_exception.dart';
import 'package:local_fiscal_service/utils/conversion_util.dart';
import 'package:local_fiscal_service/kkt/tag.dart';
import 'package:local_fiscal_service/kkt/field_type.dart';

class Field {
  static const int _TAG_OFFSET = 0;
  static const int _LENGTH_OFFSET = 2;
  static const int _DATA_OFFSET = 4;
  static const int HEADER_SIZE = _DATA_OFFSET;

  Uint8List buffer;

}