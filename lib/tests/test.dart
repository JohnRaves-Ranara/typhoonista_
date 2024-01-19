

class Person{
  String name;

  Person({required this.name});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Person{name: $name}';
  }
}

void main(){

  var s = [Person(name: 'John'),Person(name: 'John'),Person(name: 'Ana')];

  print(s.toSet());
}