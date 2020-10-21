import 'dart:typed_data';

class STRate {
  // ignore: non_constant_identifier_names
  static STRate ST_0 = STRate(0, 0);
  // ignore: non_constant_identifier_names
  static STRate ST_1 = STRate(1, 1);
  // ignore: non_constant_identifier_names
  static STRate ST_2 = STRate(2, 2);
  // ignore: non_constant_identifier_names
  static STRate ST_3 = STRate(3, 3);
  // ignore: non_constant_identifier_names
  static STRate ST_5 = STRate(4, 5);

  final int code;
  final int rate;
  static List<STRate> values;

  STRate(this.code, this.rate) {
    values.add(STRate(code, rate));
  }

  static STRate byCode(int code) {
    for (STRate val in STRate.values) {
      if (val.code == code) {
        return val;
      }
    }
    throw Exception('Unknown code: $code');
  }

  static STRate byRate(int rate) {
    for (STRate val in values) {
      if(val.rate == rate) {
        return val;
      }
    }
    throw new Exception('Unknown rate: $rate');
  }
}
