import 'evolution_entity.dart';

class PokemonEntity {
  final int id;
  final String numLabel;
  final String name;
  final String img;
  final List<String> type;
  final String height;
  final String weight;
  final String candy;
  final int? candyCount;
  final String egg;
  final double? spawnChance;
  final double? avgSpawns;
  final String? spawnTime;
  final List<double>? multipliers;
  final List<String> weaknesses;
  final List<EvolutionEntity>? nextEvolution;
  final List<EvolutionEntity>? prevEvolution;

  const PokemonEntity({
    required this.id,
    required this.numLabel,
    required this.name,
    required this.img,
    required this.type,
    required this.height,
    required this.weight,
    required this.candy,
    this.candyCount,
    required this.egg,
    this.spawnChance,
    this.avgSpawns,
    this.spawnTime,
    this.multipliers,
    required this.weaknesses,
    this.nextEvolution,
    this.prevEvolution,
  });
}
