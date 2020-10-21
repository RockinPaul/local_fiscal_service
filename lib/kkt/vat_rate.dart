
import 'dart:typed_data';

class VATRate {
  // ignore: non_constant_identifier_names
  static VATRate VAT_0 = VATRate(0, 0);
  // ignore: non_constant_identifier_names
  static VATRate VAT_12 = VATRate(1, 12);

  final int code;
  final int rate;
  static List<VATRate> values;

  VATRate(this.code, this.rate) {
    values.add(VATRate(code, rate));
  }

static VATRate byCode(int code) {
  for (VATRate val in VATRate.values) {
    if (val.code == code) {
      return val;
    }
  }
  throw Exception('Unknown code: $code');
}

static VATRate byRate(int rate) {
    for (VATRate val in values) {
      if(val.rate == rate) {
        return val;
      }
    }
    throw new Exception('Unknown rate: $rate');
}
}
