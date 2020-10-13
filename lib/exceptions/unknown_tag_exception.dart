
class UnknownTagException {
  final int _tagCode;

  UnknownTagException(this._tagCode);

  getMessage() {
    return 'code = $_tagCode';
  }
}