import 'package:dartz/dartz.dart';

import '../../../../core/error/error_messages.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_data_source.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PokemonEntity>>> getPokemons() async {
    try {
      final remotePokemons = await remoteDataSource.getPokemons();
      return Right(remotePokemons);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? ErrorMessages.serverError));
    } on ConnectionException catch (e) {
      return Left(
        ConnectionFailure(e.message ?? ErrorMessages.connectionError),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
