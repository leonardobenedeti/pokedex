import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors_constants.dart';
import '../../../../core/enums/pokemon_type.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../cubit/pokemon_cubit.dart';
import '../cubit/pokemon_state.dart';
import 'pokemon_card.dart';
import 'pokemon_type_label.dart';

class PokemonDetailModal extends StatelessWidget {
  final PokemonEntity pokemon;

  const PokemonDetailModal({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: ColorsConstants.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              Hero(
                                tag: 'pokemon-detail-${pokemon.id}',
                                child: Image.network(
                                  pokemon.img,
                                  width: constraints.maxWidth * 0.9,
                                  fit: BoxFit.fitWidth,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const SizedBox(
                                          height: 220,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pokemon.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${pokemon.numLabel}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pokemon.type.map((typeString) {
                        final type = PokemonType.fromString(typeString);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: PokemonTypeLabel(
                            label: type.label,
                            icon: type.icon,
                            primaryColor: type.color,
                            secondaryColor: type.secondaryColor,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Informações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorsConstants.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildSpecRow('Altura', pokemon.height),
                    _buildSpecRow('Peso', pokemon.weight),
                    _buildSpecRow('Doce', pokemon.candy),
                    if (pokemon.candyCount != null)
                      _buildSpecRow('Candy Count', '${pokemon.candyCount}'),
                    _buildSpecRow('Ovo', pokemon.egg),
                    if (pokemon.spawnChance != null)
                      _buildSpecRow('Chance', '${pokemon.spawnChance}%'),

                    const SizedBox(height: 24),

                    const Text(
                      'Fraquezas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorsConstants.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: pokemon.weaknesses.map((weakness) {
                        final type = PokemonType.fromString(weakness);
                        return PokemonTypeLabel(
                          label: type.label,
                          icon: type.icon,
                          primaryColor: type.color,
                          secondaryColor: type.secondaryColor,
                          isFilled: false,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    if ((pokemon.prevEvolution != null &&
                            pokemon.prevEvolution!.isNotEmpty) ||
                        (pokemon.nextEvolution != null &&
                            pokemon.nextEvolution!.isNotEmpty)) ...[
                      const Text(
                        'Relacionados',
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsConstants.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              (pokemon.prevEvolution?.length ?? 0) +
                              (pokemon.nextEvolution?.length ?? 0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final allEvolutions = [
                              ...(pokemon.prevEvolution ?? []),
                              ...(pokemon.nextEvolution ?? []),
                            ];
                            final evolution = allEvolutions[index];

                            final evoPokemon = PokemonEntity(
                              id: int.tryParse(evolution.numLabel) ?? 0,
                              numLabel: evolution.numLabel,
                              name: evolution.name,
                              img:
                                  'http://www.serebii.net/pokemongo/pokemon/${evolution.numLabel}.png',
                              type: const [],
                              height: '',
                              weight: '',
                              candy: '',
                              egg: '',
                              weaknesses: const [],
                            );

                            return AspectRatio(
                              aspectRatio: 156 / 182,
                              child: PokemonCard(
                                pokemon: evoPokemon,
                                onTap: () {
                                  final cubit = context.read<PokemonCubit>();
                                  final state = cubit.state;

                                  if (state is PokemonLoaded) {
                                    final fullPokemon = tryFindPokemon(
                                      state.allPokemons,
                                      evolution.numLabel,
                                    );

                                    if (fullPokemon != null) {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            BlocProvider.value(
                                              value: cubit,
                                              child: PokemonDetailModal(
                                                pokemon: fullPokemon,
                                              ),
                                            ),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PokemonEntity? tryFindPokemon(List<PokemonEntity> list, String numLabel) {
    try {
      return list.firstWhere((p) => p.numLabel == numLabel);
    } catch (e) {
      return null;
    }
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorsConstants.darkBlue.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: ColorsConstants.darkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
