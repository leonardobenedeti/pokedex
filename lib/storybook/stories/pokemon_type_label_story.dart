import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../../core/constants/colors_constants.dart';
import '../../features/pokemon/presentation/widgets/pokemon_type_label.dart';

Story pokemonTypeLabelStory() => Story(
  name: 'Widgets/PokemonTypeLabel',
  description: 'A label for pokemon types with an icon.',
  builder: (context) {
    final isFilled = context.knobs.boolean(label: 'Is Filled', initial: true);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PokemonTypeLabel(
            label: 'Fogo',
            icon: Icons.local_fire_department,
            primaryColor: ColorsConstants.firePrimary,
            secondaryColor: ColorsConstants.fireSecondary,
            isFilled: isFilled,
          ),
          const SizedBox(width: 16),
          PokemonTypeLabel(
            label: 'Voador',
            icon: Icons.air,
            primaryColor: ColorsConstants.flyingPrimary,
            secondaryColor: ColorsConstants.flyingSecondary,
            isFilled: isFilled,
          ),
        ],
      ),
    );
  },
);
