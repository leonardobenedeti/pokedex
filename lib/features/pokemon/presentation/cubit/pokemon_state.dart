import 'package:equatable/equatable.dart';

import '../../domain/entities/pokemon_entity.dart';

enum PokemonSortType { alphabetic, code }

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

  const PokemonLoaded({
    required this.allPokemons,
    required this.filteredPokemons,
    this.searchTerm = '',
    this.sortType = PokemonSortType.code,
  });

  @override
  List<Object?> get props => [
    allPokemons,
    filteredPokemons,
    searchTerm,
    sortType,
  ];

  PokemonLoaded copyWith({
    List<PokemonEntity>? allPokemons,
    List<PokemonEntity>? filteredPokemons,
    String? searchTerm,
    PokemonSortType? sortType,
  }) {
    return PokemonLoaded(
      allPokemons: allPokemons ?? this.allPokemons,
      filteredPokemons: filteredPokemons ?? this.filteredPokemons,
      searchTerm: searchTerm ?? this.searchTerm,
      sortType: sortType ?? this.sortType,
    );
  }
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}
