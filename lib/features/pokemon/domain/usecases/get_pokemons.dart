import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pokemon_entity.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemons {
  final PokemonRepository repository;

  GetPokemons(this.repository);

  Future<Either<Failure, List<PokemonEntity>>> call() async {
    return await repository.getPokemons();
  }
}
