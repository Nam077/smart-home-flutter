class Unit {
  int id;
  String name;
  String abbreviation;

  Unit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
    };
  }
}
