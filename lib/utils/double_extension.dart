
extension Scaling on double {
  int scale() {
    return int.parse(toString().split('.')[1].substring(0));
  }
}