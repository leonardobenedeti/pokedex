import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/core/analytics/analytics_service.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/presentation/cubit/pokemon_cubit.dart';
import 'package:pokedex/features/pokemon/presentation/cubit/pokemon_state.dart';
import 'package:pokedex/features/pokemon/presentation/pages/pokemon_list_screen.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_card.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_error_widget.dart';

class MockPokemonCubit extends Mock implements PokemonCubit {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  late MockPokemonCubit mockCubit;
  late MockAnalyticsService mockAnalyticsService;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(PokemonSortType.none);
  });

  setUp(() {
    mockCubit = MockPokemonCubit();
    mockAnalyticsService = MockAnalyticsService();

    sl.allowReassignment = true;
    sl.registerSingleton<AnalyticsService>(mockAnalyticsService);
    when(
      () => mockAnalyticsService.setCurrentScreen(
        screenName: any(named: 'screenName'),
        screenClassOverride: any(named: 'screenClassOverride'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    sl.reset();
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
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: BlocProvider<PokemonCubit>.value(
          value: mockCubit,
          child: const PokemonListView(),
        ),
      ),
    );
  }

  group('PokemonListScreen', () {
    testWidgets('displays loading indicator when state is PokemonLoading', (
      tester,
    ) async {
      setScreenSize(tester);
      when(() => mockCubit.state).thenReturn(PokemonLoading());
      when(
        () => mockCubit.stream,
      ).thenAnswer((_) => Stream.value(PokemonLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error widget when state is PokemonError', (
      tester,
    ) async {
      setScreenSize(tester);
      const errorMessage = 'Failed to load pokemons';
      when(() => mockCubit.state).thenReturn(const PokemonError(errorMessage));
      when(
        () => mockCubit.stream,
      ).thenAnswer((_) => Stream.value(const PokemonError(errorMessage)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonErrorWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays pokemon grid when state is PokemonLoaded', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(PokemonCard), findsNWidgets(2));
    });

    testWidgets('displays empty message when filtered pokemons is empty', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: [],
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Nenhum Pokémon encontrado.'), findsOneWidget);
    });

    testWidgets('displays search field', (tester) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Nome ou código do Pokemon'), findsOneWidget);
    });

    testWidgets('calls searchPokemons when text is entered in search field', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));
      when(() => mockCubit.searchPokemons(any())).thenReturn(null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Bulbasaur');
      await tester.pump();

      verify(() => mockCubit.searchPokemons('Bulbasaur')).called(1);
    });

    testWidgets('displays filter chips', (tester) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('alfabética (A-Z)'), findsOneWidget);
      expect(find.text('código (crescente)'), findsOneWidget);
    });

    testWidgets('displays filter modal button', (tester) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('calls changeSortType when alphabetic filter is tapped', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
        sortType: PokemonSortType.none,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));
      when(() => mockCubit.changeSortType(any())).thenReturn(null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('alfabética (A-Z)'));
      await tester.pump();

      verify(
        () => mockCubit.changeSortType(PokemonSortType.alphabetic),
      ).called(1);
    });

    testWidgets('calls changeSortType when code filter is tapped', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
        sortType: PokemonSortType.none,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));
      when(() => mockCubit.changeSortType(any())).thenReturn(null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('código (crescente)'));
      await tester.pump();

      verify(() => mockCubit.changeSortType(PokemonSortType.code)).called(1);
    });

    testWidgets(
      'calls fetchPokemons when error widget retry button is tapped',
      (tester) async {
        setScreenSize(tester);
        const errorMessage = 'Failed to load pokemons';
        when(
          () => mockCubit.state,
        ).thenReturn(const PokemonError(errorMessage));
        when(
          () => mockCubit.stream,
        ).thenAnswer((_) => Stream.value(const PokemonError(errorMessage)));
        when(() => mockCubit.fetchPokemons()).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        final retryButton = find.text('Tentar novamente');
        expect(retryButton, findsOneWidget);

        await tester.tap(retryButton);
        await tester.pump();

        verify(() => mockCubit.fetchPokemons()).called(1);
      },
    );

    testWidgets('displays header with title and pokeball image', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Pokédex'), findsOneWidget);
    });

    testWidgets('displays landing section with headline and subtitle', (
      tester,
    ) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
        find.text('Explore o incrível\nmundo dos Pokémon.'),
        findsOneWidget,
      );
    });

    testWidgets('uses CustomScrollView for scrolling', (tester) async {
      setScreenSize(tester);
      final loadedState = PokemonLoaded(
        allPokemons: tPokemonList,
        filteredPokemons: tPokemonList,
      );

      when(() => mockCubit.state).thenReturn(loadedState);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
    });
  });
}

void setScreenSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(2400, 3000);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin' || key == 'AssetManifest.json') {
      return rootBundle.load(key);
    }
    final file = File('test/assets/test.png');
    final bytes = await file.readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}
