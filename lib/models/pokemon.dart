class Pokemon {

  String _name;
  int _id;
  double _height; 
  double _weight; 
  int _baseExperience;
  List<String> _types;
  DateTime _captureDate;

  // List of valid Pokémon types
  static const List<String> validTypes = [
    'normal',
    'fire',
    'water',
    'grass',
    'electric',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dragon',
    'dark',
    'steel',
    'fairy'
  ];

  Pokemon({
    required String name,
    required int id,
    required double height,
    required double weight,
    required int baseExperience,
    required List<String> types,
    required DateTime captureDate,
  })  : _name = name,
        _id = id,
        _height = height,
        _weight = weight,
        _baseExperience = baseExperience,
        _types = types,
        _captureDate = captureDate {
    // Run validations
    this.name = name;
    this.id = id;
    this.height = height;
    this.weight = weight;
    this.baseExperience = baseExperience;
    this.types = types;
    this.captureDate = captureDate;
  }

  factory Pokemon.fromPokeApiData(dynamic data) {
    return Pokemon(
      name: data['name'],
      id: data['id'],
      height: (data['height'] as int) / 10,
      weight: (data['weight'] as int) / 10,
      //divide by 10 to convert decimeters to meters and hectograms to kilograms
      baseExperience: data['base_experience'],
      types: (data['types'] as List)
          .map<String>((t) => t['type']['name'] as String)
          .toList(),
      //this checks if they have any types
      captureDate: DateTime.now(),
      //captures it now
    );    
  }
  //pokemon name cant be empty
  String get name => _name;
  set name(String value) {
    if (value.trim().isEmpty) {
      throw Exception('Pokemon name cannot be empty');
    }
    _name = value;
  }
  //pokemon id must be valid
  int get id => _id;
  set id(int value) {
    if (value <= 0) {
      throw Exception('Pokemon ID must be positive');
    }
    _id = value;
  }
  //pokemon must be this tall
  double get height => _height;
  set height(double value) {
    if (value < 0.1 || value > 20.0) {
      throw Exception('Pokemon height must be between 0.1 and 20.0 meters');
    }
    _height = value;
  }
  //pokemon must weigh accordingly
  double get weight => _weight;
  set weight(double value) {
    if (value < 0.1 || value > 1000.0) {
      throw Exception('Pokemon weight must be between 0.1 and 1000.0 kilograms');
    }
    _weight = value;
  }

  //base exp must not be bad
  int get baseExperience => _baseExperience;
  set baseExperience(int value) {
    if (value < 1 || value > 1000) {
      throw Exception('Base experience must be between 1 and 1000');
    }
    _baseExperience = value;
  }

  //pokemon must have 1 or 2 types
  List<String> get types => List.unmodifiable(_types);
  set types(List<String> value) {
    if (value.isEmpty || value.length > 2) {
      throw Exception('Pokemon must have between 1 and 2 types');
    }
    for (var type in value) {
      if (!_validatePokemonType(type)) {
        throw Exception('Invalid Pokemon type: $type');
      }
    }
    _types = value.map((t) => t.toLowerCase()).toList();
  }
  //capture time must be NOW
  DateTime get captureDate => _captureDate;
  set captureDate(DateTime value) {
    if (value.isAfter(DateTime.now())) {
      throw Exception('Capture date cannot be in the future');
    }
    _captureDate = value;
  }

  // type must match
  bool _validatePokemonType(String type) {
    return validTypes.contains(type.toLowerCase());
  }

  // --- Override toString ---
  @override
  String toString() {
    return 'Pokemon: $_name (#$_id), '
        'Type(s): $_types, '
        'Height: ${_height}m, '
        'Weight: ${_weight}kg, '
        'Base Experience: $_baseExperience, '
        'Captured: $_captureDate';
  }
}
