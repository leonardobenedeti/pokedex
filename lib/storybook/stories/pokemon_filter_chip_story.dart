import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../../features/pokemon/presentation/widgets/pokemon_filter_chip.dart';

Story pokemonFilterChipStory() => Story(
  name: 'Widgets/PokemonFilterChip',
  description: 'A chip used for filtering lists.',
  builder: (context) {
    final label = context.knobs.text(
      label: 'Label',
      initial: 'alfabética (A-Z)',
    );
    final isSelected = context.knobs.boolean(
      label: 'Is Selected',
      initial: false,
    );

    return Center(
      child: PokemonFilterChip(
        label: label,
        isSelected: isSelected,
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Chip Tapped!')));
        },
        onClear: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Clear Tapped!')));
        },
      ),
    );
  },
);
