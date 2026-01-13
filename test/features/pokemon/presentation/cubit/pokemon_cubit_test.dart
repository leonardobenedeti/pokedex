import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/core/enums/pokemon_type.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemons.dart';
import 'package:pokedex/features/pokemon/presentation/cubit/pokemon_cubit.dart';
import 'package:pokedex/features/pokemon/presentation/cubit/pokemon_state.dart';

class MockGetPokemons extends Mock implements GetPokemons {}

void main() {
  late PokemonCubit cubit;
  late MockGetPokemons mockGetPokemons;

  setUp(() {
    mockGetPokemons = MockGetPokemons();
    cubit = PokemonCubit(getPokemons: mockGetPokemons);
  });

  tearDown(() {
    cubit.close();
  });

  final tPokemonList = [
    const PokemonEntity(
      id: 1,
      numLabel: '001',
      name: 'Bulbasaur',
      img: 'http://example.com/bulbasaur.png',
      type: ['Grass', 'Poison'],
      height: '0.71 m',
      weight: '6.9 kg',
      candy: 'Bulbasaur Candy',
      candyCount: 25,
      egg: '2 km',
      spawnChance: 0.69,
      avgSpawns: 69,
      spawnTime: '20:00',
      multipliers: [1.58],
      weaknesses: ['Fire', 'Ice', 'Flying', 'Psychic'],
    ),
    const PokemonEntity(
      id: 4,
      numLabel: '004',
      name: 'Charmander',
      img: 'http://example.com/charmander.png',
      type: ['Fire'],
      height: '0.61 m',
      weight: '8.5 kg',
      candy: 'Charmander Candy',
      candyCount: 25,
      egg: '2 km',
      spawnChance: 0.253,
      avgSpawns: 25.3,
      spawnTime: '08:45',
      multipliers: [1.65],
      weaknesses: ['Water', 'Ground', 'Rock'],
    ),
    const PokemonEntity(
      id: 7,
      numLabel: '007',
      name: 'Squirtle',
      img: 'http://example.com/squirtle.png',
      type: ['Water'],
      height: '0.51 m',
      weight: '9.0 kg',
      candy: 'Squirtle Candy',
      candyCount: 25,
      egg: '2 km',
      spawnChance: 0.58,
      avgSpawns: 58,
      spawnTime: '04:25',
      multipliers: [2.1],
      weaknesses: ['Electric', 'Grass'],
    ),
  ];

  group('PokemonCubit', () {
    test('initial state should be PokemonInitial', () {
      expect(cubit.state, equals(PokemonInitial()));
    });

    group('fetchPokemons', () {
      blocTest<PokemonCubit, PokemonState>(
        'emits [PokemonLoading, PokemonLoaded] when data is fetched successfully',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) => cubit.fetchPokemons(),
        expect: () => [
          PokemonLoading(),
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: tPokemonList,
            searchTerm: '',
            sortType: PokemonSortType.none,
            selectedType: null,
          ),
        ],
        verify: (_) {
          verify(() => mockGetPokemons()).called(1);
        },
      );

      blocTest<PokemonCubit, PokemonState>(
        'emits [PokemonLoading, PokemonError] when fetching data fails',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
          return cubit;
        },
        act: (cubit) => cubit.fetchPokemons(),
        expect: () => [PokemonLoading(), const PokemonError('Server error')],
        verify: (_) {
          verify(() => mockGetPokemons()).called(1);
        },
      );

      blocTest<PokemonCubit, PokemonState>(
        'emits [PokemonLoading, PokemonError] when connection fails',
        build: () {
          when(() => mockGetPokemons()).thenAnswer(
            (_) async =>
                const Left(ConnectionFailure('No internet connection')),
          );
          return cubit;
        },
        act: (cubit) => cubit.fetchPokemons(),
        expect: () => [
          PokemonLoading(),
          const PokemonError('No internet connection'),
        ],
      );
    });

    group('searchPokemons', () {
      blocTest<PokemonCubit, PokemonState>(
        'filters pokemons by name when search term is provided',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.searchPokemons('Char');
        },
        skip: 2,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [tPokemonList[1]],
            searchTerm: 'Char',
            sortType: PokemonSortType.none,
            selectedType: null,
          ),
        ],
      );

      blocTest<PokemonCubit, PokemonState>(
        'filters pokemons by number when search term matches numLabel',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.searchPokemons('001');
        },
        skip: 2,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [tPokemonList[0]],
            searchTerm: '001',
            sortType: PokemonSortType.none,
            selectedType: null,
          ),
        ],
      );

      blocTest<PokemonCubit, PokemonState>(
        'returns empty list when no pokemon matches search term',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.searchPokemons('Pikachu');
        },
        skip: 2,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [],
            searchTerm: 'Pikachu',
            sortType: PokemonSortType.none,
            selectedType: null,
          ),
        ],
      );
    });

    group('changeSortType', () {
      blocTest<PokemonCubit, PokemonState>(
        'sorts pokemons alphabetically when PokemonSortType.alphabetic is selected',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.changeSortType(PokemonSortType.alphabetic);
        },
        skip: 2,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [
              tPokemonList[0],
              tPokemonList[1],
              tPokemonList[2],
            ],
            searchTerm: '',
            sortType: PokemonSortType.alphabetic,
            selectedType: null,
          ),
        ],
      );

      blocTest<PokemonCubit, PokemonState>(
        'sorts pokemons by code when PokemonSortType.code is selected',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.changeSortType(PokemonSortType.code);
        },
        skip: 2,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: tPokemonList,
            searchTerm: '',
            sortType: PokemonSortType.code,
            selectedType: null,
          ),
        ],
      );
    });

    group('changeSelectedType', () {
      blocTest<PokemonCubit, PokemonState>(
        'filters pokemons by type when a type is selected',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.changeSelectedType(PokemonType.fire);
        },
        skip: 2,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [tPokemonList[1]],
            searchTerm: '',
            sortType: PokemonSortType.none,
            selectedType: PokemonType.fire,
          ),
        ],
      );

      blocTest<PokemonCubit, PokemonState>(
        'keeps type filter when null is passed (copyWith limitation)',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.changeSelectedType(PokemonType.fire);
          cubit.changeSelectedType(null);
        },
        skip: 3,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: tPokemonList,
            searchTerm: '',
            sortType: PokemonSortType.none,
            selectedType: PokemonType.fire,
          ),
        ],
      );
    });

    group('resetFilters', () {
      blocTest<PokemonCubit, PokemonState>(
        'resets sort type and selected type but keeps search term',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.searchPokemons('Char');
          cubit.changeSortType(PokemonSortType.alphabetic);
          cubit.changeSelectedType(PokemonType.fire);
          cubit.resetFilters();
        },
        skip: 5,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [tPokemonList[1]],
            searchTerm: 'Char',
            sortType: PokemonSortType.none,
            selectedType: null,
          ),
        ],
      );
    });

    group('combined filters', () {
      blocTest<PokemonCubit, PokemonState>(
        'applies search and type filter together',
        build: () {
          when(
            () => mockGetPokemons(),
          ).thenAnswer((_) async => Right(tPokemonList));
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemons();
          cubit.changeSelectedType(PokemonType.grass);
          cubit.searchPokemons('Bulb');
        },
        skip: 3,
        expect: () => [
          PokemonLoaded(
            allPokemons: tPokemonList,
            filteredPokemons: [tPokemonList[0]],
            searchTerm: 'Bulb',
            sortType: PokemonSortType.none,
            selectedType: PokemonType.grass,
          ),
        ],
      );
    });
  });
}
