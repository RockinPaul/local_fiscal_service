class ContainerType {
  const ContainerType(this.code) : super();

  final int code;

  static const ContainerType FN = ContainerType(0xA5);
  static const ContainerType HSM = ContainerType(0x5A);

  static List<ContainerType> values = [
    FN,
    HSM,
  ];

  static ContainerType byCode(int code) {
    return values.firstWhere((element) => element.code == code);
  }
}

// FN((byte)0xA5),
// HSM((byte)0x5A);
