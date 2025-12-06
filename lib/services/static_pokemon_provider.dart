import 'package:http/http.dart' as http;
import 'dart:convert';
const String pokemonEndpoint = 'https://pokeapi.co/api/v2/pokemon';

Future<dynamic> getPokemonByName({required String pokemonName}) async {
  try {
    final response = await http.get(Uri.parse('$pokemonEndpoint/$pokemonName'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('status ${response.statusCode} received');
    }
  } catch (error) {
    // Catching any exception and throwing a new one with a custom message
    throw Exception('There was a problem with the request: ${error.toString()}');
  }
}