extension TripleShift on int {
  int tripleShift(int count) {
    return (this >> count) & ~(-1 << (64 - count));
  }
}