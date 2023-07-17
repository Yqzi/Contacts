void main() {
  C c = C(newf, 8);

  print(c.value);
}

String newf(int? p0, bool p1) => "look: $p0, $p1";

class C {
  final int? value;
  final String Function(int?, bool) f;

  C(this.f, this.value);

  void doSomething(bool possilbe) {
    print("do something");
    print(f(value, possilbe));
  }
}
