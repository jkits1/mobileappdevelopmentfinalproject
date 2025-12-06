import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobileappdevelopmentfinalproject/models/pokemon.dart';

class PokemonManager {
  const PokemonManager._();

  static const _dbName = "pokemon.db";
  static const _dbVersion = 1;

  static const PokemonManager instance = PokemonManager._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _connectToDB();
    return _database!;
  }
  void setDatabase(Database value) {
    _database = value;
  }

  static void resetDatabase() {
    _database = null;
  }

  Future<Database> _connectToDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _dbName);

    //async opening will be a lot smoother
    final database = await openDatabase(
      path,
      onCreate: (db, version) async {
        //                                                                         
        await db.execute(
        '''
        CREATE TABLE pokemon(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          pokemonId INTEGER,
          name TEXT,
          height REAL,
          weight REAL,
          baseExperience INTEGER,
          types TEXT,
          captureDate TEXT
        )
        '''
      );
      },
      version: _dbVersion,
    );

    return database;
  }

      Future<int> insertPokemon(Pokemon pokemon) async {
    final db = await database;
    return db.insert("pokemon", pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pokemon>> getAllPokemon() async {
    final db = await database;
    final data = await db.query("pokemon");
    return data.map((e) => Pokemon.fromMap(e)).toList();
  }

  Future<int> updatePokemon(Pokemon pokemon) async {
    final db = await database;
    return db.update(
      "pokemon",
      pokemon.toMap(),
      where: "id = ?",
      whereArgs: [pokemon.id],
    );
  }

  Future<int> deletePokemon(int id) async {
    final db = await database;
    return db.delete("pokemon", where: "id = ?", whereArgs: [id]);
  }
}
