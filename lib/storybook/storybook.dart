import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'stories/pokemon_card_story.dart';
import 'stories/pokemon_filter_chip_story.dart';
import 'stories/pokemon_type_label_story.dart';

class PokedexStorybook extends StatelessWidget {
  const PokedexStorybook({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      initialStory: 'Widgets/PokemonFilterChip',
      stories: [
        pokemonCardStory(),
        pokemonTypeLabelStory(),
        pokemonFilterChipStory(),
      ],
    );
  }
}
