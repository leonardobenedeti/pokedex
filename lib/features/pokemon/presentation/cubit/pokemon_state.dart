import 'package:equatable/equatable.dart';

import '../../../../core/enums/pokemon_type.dart';
import '../../domain/entities/pokemon_entity.dart';

enum PokemonSortType { alphabetic, code, none }

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<PokemonEntity> allPokemons;
  final List<PokemonEntity> filteredPokemons;
  final String searchTerm;
  final PokemonSortType sortType;
  final PokemonType? selectedType;

  const PokemonLoaded({
    required this.allPokemons,
    required this.filteredPokemons,
    this.searchTerm = '',
    this.sortType = PokemonSortType.none,
    this.selectedType,
  });

  @override
  List<Object?> get props => [
    allPokemons,
    filteredPokemons,
    searchTerm,
    sortType,
    selectedType,
  ];

  PokemonLoaded copyWith({
    List<PokemonEntity>? allPokemons,
    List<PokemonEntity>? filteredPokemons,
    String? searchTerm,
    PokemonSortType? sortType,
    PokemonType? selectedType,
  }) {
    return PokemonLoaded(
      allPokemons: allPokemons ?? this.allPokemons,
      filteredPokemons: filteredPokemons ?? this.filteredPokemons,
      searchTerm: searchTerm ?? this.searchTerm,
      sortType: sortType ?? this.sortType,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}
