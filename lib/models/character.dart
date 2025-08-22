class Character {
  final int id;
  final String name;
  final String status; // Alive, Dead, unknown
  final String species;
  final String image;
  final String type;
  final String gender;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.type,
    required this.gender,
  });

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      image: map['image'] as String,
      type: map['type'] ?? '',
      gender: map['gender'] as String,
    );
  }

  bool get isAlive => status.toLowerCase() == 'alive';
  bool get isDead => status.toLowerCase() == 'dead';
}
