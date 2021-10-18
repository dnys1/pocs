class Byte {
  const Byte(int byte) : _byte = byte & 0xFF;

  final int _byte;

  int get value => _byte;
}
