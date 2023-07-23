void main() {
  final List<int> x = [];
  final y = x;

  print("$x ${y..add(1)}");
}
