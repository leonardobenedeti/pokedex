import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import '../../features/pokemon/data/repositories/pokemon_repository_impl.dart';
import '../../features/pokemon/domain/repositories/pokemon_repository.dart';
import '../../features/pokemon/domain/usecases/get_pokemons.dart';
import '../../features/pokemon/presentation/cubit/pokemon_cubit.dart';
import '../analytics/analytics_service.dart';
import '../network/network_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Setup
  final String url = dotenv.get('POKEDEX_URL');

  //! Features - Pokemon
  // Cubit
  sl.registerFactory(() => PokemonCubit(getPokemons: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPokemons(sl()));

  // Repository
  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: sl(), url: url),
  );

  //! Core
  sl.registerLazySingleton<NetworkClient>(() => DioClient(sl()));
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  //! External
  sl.registerLazySingleton(() => Dio());
}
