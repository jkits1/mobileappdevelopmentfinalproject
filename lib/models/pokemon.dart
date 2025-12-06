class Pokemon {
  final int? id;
  final int pokemonId;
  final String name;
  final double height;
  final double weight;
  final int baseExperience;
  final List<String> types;
  final DateTime captureDate;

  Pokemon({
    this.id,
    required this.pokemonId,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
    required this.captureDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "pokemonId": pokemonId,
      "name": name,
      "height": height,
      "weight": weight,
      "baseExperience": baseExperience,
      "types": types.join(","),
      "captureDate": captureDate.toIso8601String(),
    };
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map["id"],
      pokemonId: map["pokemonId"],
      name: map["name"],
      height: map["height"],
      weight: map["weight"],
      baseExperience: map["baseExperience"],
      types: (map["types"] as String).split(","),
      captureDate: DateTime.parse(map["captureDate"]),
    );
  }

  static const validTypes = [
    "Normal", "Fire", "Water", "Grass", "Electric", "Ice",
    "Fighting", "Poison", "Ground", "Flying", "Psychic",
    "Bug", "Rock", "Ghost", "Dark", "Steel", "Fairy", "Dragon"
  ];
}