import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/core/error/exceptions.dart';
import 'package:pokedex/core/network/network_client.dart';
import 'package:pokedex/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_model.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockResponse extends Mock implements Response {}

void main() {
  late PokemonRemoteDataSourceImpl dataSource;
  late MockNetworkClient mockNetworkClient;
  const testUrl = 'https://test-api.com/pokemon';

  setUp(() {
    mockNetworkClient = MockNetworkClient();
    dataSource = PokemonRemoteDataSourceImpl(
      client: mockNetworkClient,
      url: testUrl,
    );
  });

  group('PokemonRemoteDataSource', () {
    final tPokemonJson = {
      'id': 1,
      'num': '001',
      'name': 'Bulbasaur',
      'img': 'http://example.com/bulbasaur.png',
      'type': ['Grass', 'Poison'],
      'height': '0.71 m',
      'weight': '6.9 kg',
      'candy': 'Bulbasaur Candy',
      'candy_count': 25,
      'egg': '2 km',
      'spawn_chance': 0.69,
      'avg_spawns': 69,
      'spawn_time': '20:00',
      'multipliers': [1.58],
      'weaknesses': ['Fire', 'Ice', 'Flying', 'Psychic'],
    };

    final tPokemonJson2 = {
      'id': 4,
      'num': '004',
      'name': 'Charmander',
      'img': 'http://example.com/charmander.png',
      'type': ['Fire'],
      'height': '0.61 m',
      'weight': '8.5 kg',
      'candy': 'Charmander Candy',
      'candy_count': 25,
      'egg': '2 km',
      'spawn_chance': 0.253,
      'avg_spawns': 25.3,
      'spawn_time': '08:45',
      'multipliers': [1.65],
      'weaknesses': ['Water', 'Ground', 'Rock'],
    };

    final tResponseData = {
      'pokemon': [tPokemonJson, tPokemonJson2],
    };

    final tPokemonModel1 = PokemonModel.fromJson(tPokemonJson);
    final tPokemonModel2 = PokemonModel.fromJson(tPokemonJson2);

    group('getPokemons', () {
      test(
        'should return list of PokemonModel when response code is 200',
        () async {
          // arrange
          final mockResponse = Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: json.encode(tResponseData),
          );

          when(
            () => mockNetworkClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          // act
          final result = await dataSource.getPokemons();

          // assert
          expect(result, isA<List<PokemonModel>>());
          expect(result.length, equals(2));
          expect(result[0].id, equals(tPokemonModel1.id));
          expect(result[0].name, equals(tPokemonModel1.name));
          expect(result[1].id, equals(tPokemonModel2.id));
          expect(result[1].name, equals(tPokemonModel2.name));
          verify(() => mockNetworkClient.get(any())).called(1);
        },
      );

      test('should return empty list when pokemon array is null', () async {
        // arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: json.encode({'pokemon': null}),
        );

        when(
          () => mockNetworkClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        // act
        final result = await dataSource.getPokemons();

        // assert
        expect(result, isA<List<PokemonModel>>());
        expect(result.length, equals(0));
      });

      test('should return empty list when pokemon array is missing', () async {
        // arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: json.encode({}),
        );

        when(
          () => mockNetworkClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        // act
        final result = await dataSource.getPokemons();

        // assert
        expect(result, isA<List<PokemonModel>>());
        expect(result.length, equals(0));
      });

      test(
        'should throw ServerException when response code is not 200',
        () async {
          // arrange
          final mockResponse = Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
            data: '',
          );

          when(
            () => mockNetworkClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          // act
          final call = dataSource.getPokemons;

          // assert
          expect(() => call(), throwsA(isA<ServerException>()));
        },
      );

      test('should throw ServerException when response code is 500', () async {
        // arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          data: '',
        );

        when(
          () => mockNetworkClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        // act
        final call = dataSource.getPokemons;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      });

      test(
        'should throw ConnectionException when DioException with ConnectionException occurs',
        () async {
          // arrange
          final connectionException = ConnectionException();
          final dioException = DioException(
            requestOptions: RequestOptions(path: ''),
            error: connectionException,
          );

          when(() => mockNetworkClient.get(any())).thenThrow(dioException);

          // act
          final call = dataSource.getPokemons;

          // assert
          expect(() => call(), throwsA(isA<ConnectionException>()));
        },
      );

      test(
        'should throw ServerException when generic exception occurs',
        () async {
          // arrange
          when(
            () => mockNetworkClient.get(any()),
          ).thenThrow(Exception('Something went wrong'));

          // act
          final call = dataSource.getPokemons;

          // assert
          expect(() => call(), throwsA(isA<ServerException>()));
        },
      );

      test('should rethrow ServerException when it is thrown', () async {
        // arrange
        when(
          () => mockNetworkClient.get(any()),
        ).thenThrow(ServerException(message: 'Custom server error'));

        // act
        final call = dataSource.getPokemons;

        // assert
        expect(
          () => call(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Custom server error',
            ),
          ),
        );
      });

      test('should parse pokemon with all optional fields', () async {
        // arrange
        final fullPokemonJson = {
          'id': 1,
          'num': '001',
          'name': 'Bulbasaur',
          'img': 'http://example.com/bulbasaur.png',
          'type': ['Grass', 'Poison'],
          'height': '0.71 m',
          'weight': '6.9 kg',
          'candy': 'Bulbasaur Candy',
          'candy_count': 25,
          'egg': '2 km',
          'spawn_chance': 0.69,
          'avg_spawns': 69,
          'spawn_time': '20:00',
          'multipliers': [1.58, 1.6],
          'weaknesses': ['Fire', 'Ice', 'Flying', 'Psychic'],
          'next_evolution': [
            {'num': '002', 'name': 'Ivysaur'},
          ],
          'prev_evolution': [
            {'num': '000', 'name': 'Seed'},
          ],
        };

        final responseData = {
          'pokemon': [fullPokemonJson],
        };

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: json.encode(responseData),
        );

        when(
          () => mockNetworkClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        // act
        final result = await dataSource.getPokemons();

        // assert
        expect(result.length, equals(1));
        expect(result[0].candyCount, equals(25));
        expect(result[0].spawnChance, equals(0.69));
        expect(result[0].avgSpawns, equals(69));
        expect(result[0].spawnTime, equals('20:00'));
        expect(result[0].multipliers, equals([1.58, 1.6]));
        expect(result[0].nextEvolution, isNotNull);
        expect(result[0].nextEvolution!.length, equals(1));
        expect(result[0].prevEvolution, isNotNull);
        expect(result[0].prevEvolution!.length, equals(1));
      });

      test('should parse pokemon with missing optional fields', () async {
        // arrange
        final minimalPokemonJson = {
          'id': 1,
          'num': '001',
          'name': 'Bulbasaur',
          'img': 'http://example.com/bulbasaur.png',
          'type': ['Grass'],
          'height': '0.71 m',
          'weight': '6.9 kg',
          'candy': 'Bulbasaur Candy',
          'egg': '2 km',
          'weaknesses': ['Fire'],
        };

        final responseData = {
          'pokemon': [minimalPokemonJson],
        };

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: json.encode(responseData),
        );

        when(
          () => mockNetworkClient.get(any()),
        ).thenAnswer((_) async => mockResponse);

        // act
        final result = await dataSource.getPokemons();

        // assert
        expect(result.length, equals(1));
        expect(result[0].candyCount, isNull);
        expect(result[0].spawnChance, isNull);
        expect(result[0].avgSpawns, isNull);
        expect(result[0].spawnTime, isNull);
        expect(result[0].multipliers, isNull);
        expect(result[0].nextEvolution, isNull);
        expect(result[0].prevEvolution, isNull);
      });
      test(
        'should sanitize pokemon name by removing (Male) and (Female)',
        () async {
          // arrange
          final pokemonWithSuffixes = {
            'id': 29,
            'num': '029',
            'name': 'Nidoran (Female)',
            'img': 'http://www.serebii.net/pokemongo/pokemon/029.png',
            'type': ['Poison'],
            'height': '0.41 m',
            'weight': '7.0 kg',
            'candy': 'Nidoran (Female) Candy',
            'candy_count': 25,
            'egg': '5 km',
            'spawn_chance': 1.38,
            'avg_spawns': 138,
            'spawn_time': '01:51',
            'multipliers': [1.63, 2.48],
            'weaknesses': ['Ground', 'Psychic'],
            'next_evolution': [
              {'num': '030', 'name': 'Nidorina'},
              {'num': '031', 'name': 'Nidoqueen'},
            ],
          };

          final pokemonWithSuffixes2 = {
            'id': 32,
            'num': '032',
            'name': 'Nidoran (Male)',
            'img': 'http://www.serebii.net/pokemongo/pokemon/032.png',
            'type': ['Poison'],
            'height': '0.51 m',
            'weight': '9.0 kg',
            'candy': 'Nidoran (Male) Candy',
            'candy_count': 25,
            'egg': '5 km',
            'spawn_chance': 1.31,
            'avg_spawns': 131,
            'spawn_time': '01:12',
            'multipliers': [1.64, 1.7],
            'weaknesses': ['Ground', 'Psychic'],
            'next_evolution': [
              {'num': '033', 'name': 'Nidorino'},
              {'num': '034', 'name': 'Nidoking'},
            ],
          };

          final responseData = {
            'pokemon': [pokemonWithSuffixes, pokemonWithSuffixes2],
          };

          final mockResponse = Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: json.encode(responseData),
          );

          when(
            () => mockNetworkClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          // act
          final result = await dataSource.getPokemons();

          // assert
          expect(result.length, equals(2));
          expect(result[0].name, equals('Nidoran'));
          expect(result[1].name, equals('Nidoran'));
        },
      );
      test(
        'should sanitize evolution name by removing (Male) and (Female)',
        () async {
          // arrange
          final pokemonWithEvolutionSuffixes = {
            'id': 29,
            'num': '029',
            'name': 'Nidoran',
            'img': 'http://www.serebii.net/pokemongo/pokemon/029.png',
            'type': ['Poison'],
            'height': '0.41 m',
            'weight': '7.0 kg',
            'candy': 'Nidoran (Female) Candy',
            'candy_count': 25,
            'egg': '5 km',
            'spawn_chance': 1.38,
            'avg_spawns': 138,
            'spawn_time': '01:51',
            'multipliers': [1.63, 2.48],
            'weaknesses': ['Ground', 'Psychic'],
            'next_evolution': [
              {'num': '030', 'name': 'Nidorina (Male)'}, // Example suffix
              {'num': '031', 'name': 'Nidoqueen (Female)'}, // Example suffix
            ],
          };

          final responseData = {
            'pokemon': [pokemonWithEvolutionSuffixes],
          };

          final mockResponse = Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: json.encode(responseData),
          );

          when(
            () => mockNetworkClient.get(any()),
          ).thenAnswer((_) async => mockResponse);

          // act
          final result = await dataSource.getPokemons();

          // assert
          expect(result.length, equals(1));
          expect(result[0].nextEvolution![0].name, equals('Nidorina'));
          expect(result[0].nextEvolution![1].name, equals('Nidoqueen'));
        },
      );
    });
  });
}
