import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/pokemon_type.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/get_pokemons.dart';
import 'pokemon_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final GetPokemons getPokemons;

  PokemonCubit({required this.getPokemons}) : super(PokemonInitial());

  Future<void> fetchPokemons() async {
    emit(PokemonLoading());
    final result = await getPokemons();
    result.fold((failure) => emit(PokemonError(failure.message)), (pokemons) {
      emit(
        PokemonLoaded(
          allPokemons: pokemons,
          filteredPokemons: _applyFilters(
            pokemons,
            '',
            PokemonSortType.none,
            null,
          ),
        ),
      );
    });
  }

  void searchPokemons(String query) {
    if (state is PokemonLoaded) {
      final loadedState = state as PokemonLoaded;
      final filtered = _applyFilters(
        loadedState.allPokemons,
        query,
        loadedState.sortType,
        loadedState.selectedType,
      );
      emit(loadedState.copyWith(searchTerm: query, filteredPokemons: filtered));
    }
  }

  void changeSortType(PokemonSortType sortType) {
    if (state is PokemonLoaded) {
      final loadedState = state as PokemonLoaded;
      final filtered = _applyFilters(
        loadedState.allPokemons,
        loadedState.searchTerm,
        sortType,
        loadedState.selectedType,
      );
      emit(
        loadedState.copyWith(sortType: sortType, filteredPokemons: filtered),
      );
    }
  }

  void changeSelectedType(PokemonType? selectedType) {
    if (state is PokemonLoaded) {
      final loadedState = state as PokemonLoaded;
      final filtered = _applyFilters(
        loadedState.allPokemons,
        loadedState.searchTerm,
        loadedState.sortType,
        selectedType,
      );
      emit(
        loadedState.copyWith(
          selectedType: selectedType,
          filteredPokemons: filtered,
        ),
      );
    }
  }

  void resetFilters() {
    if (state is PokemonLoaded) {
      final loadedState = state as PokemonLoaded;
      final filtered = _applyFilters(
        loadedState.allPokemons,
        loadedState.searchTerm,
        PokemonSortType.none,
        null,
      );
      emit(
        PokemonLoaded(
          allPokemons: loadedState.allPokemons,
          filteredPokemons: filtered,
          searchTerm: loadedState.searchTerm,
          sortType: PokemonSortType.none,
          selectedType: null,
        ),
      );
    }
  }

  List<PokemonEntity> _applyFilters(
    List<PokemonEntity> pokemons,
    String query,
    PokemonSortType sortType,
    PokemonType? selectedType,
  ) {
    var filtered = [...pokemons];

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(lowerQuery) ||
            p.numLabel.contains(lowerQuery);
      }).toList();
    }

    if (selectedType != null) {
      filtered = filtered.where((p) {
        return p.type.any((tString) {
          final type = PokemonType.fromString(tString);
          return type == selectedType;
        });
      }).toList();
    }

    if (sortType == PokemonSortType.alphabetic) {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortType == PokemonSortType.code) {
      filtered.sort((a, b) => a.id.compareTo(b.id));
    } else if (sortType == PokemonSortType.none) {
      filtered.sort((a, b) => a.id.compareTo(b.id));
    }

    return filtered;
  }
}
