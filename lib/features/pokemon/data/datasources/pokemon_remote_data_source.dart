import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/error/error_messages.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemons();
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final NetworkClient client;
  final String url = dotenv.get('POKEDEX_URL');

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PokemonModel>> getPokemons() async {
    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        late Map<String, dynamic> data;

        if (responseData is Map<String, dynamic>) {
          data = responseData;
        } else {
          throw ServerException(message: ErrorMessages.invalidResponse);
        }

        final List pokemonList = data['pokemon'] ?? [];
        return pokemonList.map((json) => PokemonModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message:
              '${ErrorMessages.serverError} (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      if (e is DioException && e.error is ConnectionException) {
        throw e.error as ConnectionException;
      }
      throw ServerException(message: e.toString());
    }
  }
}
