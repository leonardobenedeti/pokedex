import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../../features/pokemon/domain/entities/pokemon_entity.dart';
import '../../features/pokemon/presentation/widgets/pokemon_card.dart';

Story pokemonCardStory() => Story(
  name: 'Widgets/PokemonCard',
  description: 'A card displaying basic pokemon information.',
  builder: (context) {
    final searchTerm = context.knobs.text(
      label: 'Search Term',
      initial: 'Char',
    );
    final isInverse = context.knobs.boolean(
      label: 'Inverse Theme',
      initial: false,
    );

    return Center(
      child: SizedBox(
        width: 160,
        child: PokemonCard(
          pokemon: const PokemonEntity(
            id: 4,
            numLabel: '004',
            name: 'Charmander',
            img: 'https://www.serebii.net/pokemongo/pokemon/004.png',
            type: ['Fire'],
            height: '0.6 m',
            weight: '8.5 kg',
            candy: 'Charmander Candy',
            egg: '2 km',
            weaknesses: ['Water', 'Ground', 'Rock'],
          ),
          searchTerm: searchTerm,
          isInverse: isInverse,
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Pokemon Tapped!')));
          },
        ),
      ),
    );
  },
);
