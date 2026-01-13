import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_card.dart';

void main() {
  late PokemonEntity testPokemon;

  setUp(() {
    testPokemon = const PokemonEntity(
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
    );
  });

  Widget createWidgetUnderTest({
    required PokemonEntity pokemon,
    String searchTerm = '',
    bool isInverse = false,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PokemonCard(
          pokemon: pokemon,
          searchTerm: searchTerm,
          isInverse: isInverse,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  group('PokemonCard Widget', () {
    testWidgets('displays pokemon name and number correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(pokemon: testPokemon));

      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('#001'), findsOneWidget);
    });

    testWidgets('displays pokemon image with correct URL', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(pokemon: testPokemon));

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget(imageFinder);
      final NetworkImage networkImage = imageWidget.image as NetworkImage;

      expect(networkImage.url.contains('bulbasaur.png'), isTrue);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: testPokemon,
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(PokemonCard));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('displays add icon button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(pokemon: testPokemon));

      final addIconFinder = find.byIcon(Icons.add);
      expect(addIconFinder, findsOneWidget);
    });

    testWidgets('highlights search term in pokemon name', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: testPokemon, searchTerm: 'Bulb'),
      );

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsWidgets);

      final RichText richText = tester.widget(richTextFinder.first);
      expect(richText.text, isA<TextSpan>());
    });

    testWidgets('does not highlight when search term is empty', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: testPokemon, searchTerm: ''),
      );

      expect(find.text('Bulbasaur'), findsOneWidget);
    });

    testWidgets('does not highlight when search term does not match', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: testPokemon, searchTerm: 'Pikachu'),
      );

      expect(find.text('Bulbasaur'), findsOneWidget);
    });

    testWidgets('applies inverse styling when isInverse is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: testPokemon, isInverse: true),
      );

      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      expect(decoration.color, isNotNull);
    });

    testWidgets('applies normal styling when isInverse is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: testPokemon, isInverse: false),
      );

      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      expect(decoration.color, equals(Colors.white));
    });

    testWidgets('has correct height', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(pokemon: testPokemon));

      final sizedBoxFinder = find.byType(SizedBox).first;
      final SizedBox sizedBox = tester.widget(sizedBoxFinder);

      expect(sizedBox.height, equals(182));
    });

    testWidgets('displays Hero widget with correct tag', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(pokemon: testPokemon));

      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);

      final Hero hero = tester.widget(heroFinder);
      expect(hero.tag, equals('pokemon-1'));
    });

    testWidgets('shows loading indicator while image is loading', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(pokemon: testPokemon));

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget(imageFinder);
      expect(imageWidget.loadingBuilder, isNotNull);
    });

    testWidgets('shows error icon when image fails to load', (tester) async {
      final pokemonWithBadImage = PokemonEntity(
        id: testPokemon.id,
        numLabel: testPokemon.numLabel,
        name: testPokemon.name,
        img: 'invalid-url',
        type: testPokemon.type,
        height: testPokemon.height,
        weight: testPokemon.weight,
        candy: testPokemon.candy,
        candyCount: testPokemon.candyCount,
        egg: testPokemon.egg,
        spawnChance: testPokemon.spawnChance,
        avgSpawns: testPokemon.avgSpawns,
        spawnTime: testPokemon.spawnTime,
        multipliers: testPokemon.multipliers,
        weaknesses: testPokemon.weaknesses,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: pokemonWithBadImage),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget(imageFinder);
      expect(imageWidget.errorBuilder, isNotNull);
    });
  });
}
