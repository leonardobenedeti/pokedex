import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/colors_constants.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/pokemon_cubit.dart';
import '../cubit/pokemon_state.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/pokemon_filter_chip.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PokemonCubit>()..fetchPokemons(),
      child: const PokemonListView(),
    );
  }
}

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: const BoxDecoration(
                      color: ColorsConstants.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              StringConstants.pokedexTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Image.asset(
                          AssetsConstants.pokeball,
                          width: 32,
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 140),
                          child: Image.asset(
                            AssetsConstants.koraidon,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.white,
                                  Colors.white,
                                  Colors.white.withValues(alpha: 0.9),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                const Text(
                                  StringConstants.landingHeadline,
                                  style: TextStyle(
                                    color: ColorsConstants.darkBlue,
                                    fontSize: 32,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  StringConstants.landingSubtitle,
                                  style: TextStyle(
                                    color: ColorsConstants.darkBlue.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      StringConstants.pokemonCount,
                                      style: TextStyle(
                                        color: ColorsConstants.primary,
                                        fontSize: 40,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      StringConstants.pokemonLabel,
                                      style: TextStyle(
                                        color: ColorsConstants.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        context.read<PokemonCubit>().searchPokemons(value),
                    decoration: InputDecoration(
                      hintText: 'Nome ou código do Pokemon',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  _buildPokemonGrid(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return BlocBuilder<PokemonCubit, PokemonState>(
      builder: (context, state) {
        final sortType = state is PokemonLoaded
            ? state.sortType
            : PokemonSortType.code;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.tune, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              PokemonFilterChip(
                label: 'alfabética (A-Z)',
                isSelected: sortType == PokemonSortType.alphabetic,
                onTap: () => context.read<PokemonCubit>().changeSortType(
                  PokemonSortType.alphabetic,
                ),
                onClear: () => context.read<PokemonCubit>().changeSortType(
                  PokemonSortType.code,
                ),
              ),
              const SizedBox(width: 8),
              PokemonFilterChip(
                label: 'código (crescente)',
                isSelected: sortType == PokemonSortType.code,
                onTap: () => context.read<PokemonCubit>().changeSortType(
                  PokemonSortType.code,
                ),
                onClear: () => {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPokemonGrid() {
    return BlocBuilder<PokemonCubit, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PokemonError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is PokemonLoaded) {
          if (state.filteredPokemons.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum Pokémon encontrado.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 156 / 182,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.filteredPokemons.length,
            itemBuilder: (context, index) {
              return PokemonCard(
                pokemon: state.filteredPokemons[index],
                searchTerm: state.searchTerm,
                onTap: () {
                  // TODO(leo): open modal with pokemon details
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
