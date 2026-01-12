import '../../domain/entities/pokemon_entity.dart';
import 'evolution_model.dart';

class PokemonModel extends PokemonEntity {
  const PokemonModel({
    required super.id,
    required super.numLabel,
    required super.name,
    required super.img,
    required super.type,
    required super.height,
    required super.weight,
    required super.candy,
    super.candyCount,
    required super.egg,
    super.spawnChance,
    super.avgSpawns,
    super.spawnTime,
    super.multipliers,
    required super.weaknesses,
    super.nextEvolution,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      numLabel: json['num'],
      name: json['name'],
      img: json['img'],
      type: List<String>.from(json['type']),
      height: json['height'],
      weight: json['weight'],
      candy: json['candy'],
      candyCount: json['candy_count'],
      egg: json['egg'],
      spawnChance: (json['spawn_chance'] as num?)?.toDouble(),
      avgSpawns: (json['avg_spawns'] as num?)?.toDouble(),
      spawnTime: json['spawn_time'],
      multipliers: json['multipliers'] != null
          ? List<double>.from(
              json['multipliers'].map((x) => (x as num).toDouble()),
            )
          : null,
      weaknesses: List<String>.from(json['weaknesses']),
      nextEvolution: json['next_evolution'] != null
          ? List<EvolutionModel>.from(
              json['next_evolution'].map((x) => EvolutionModel.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': numLabel,
      'name': name,
      'img': img,
      'type': type,
      'height': height,
      'weight': weight,
      'candy': candy,
      'candy_count': candyCount,
      'egg': egg,
      'spawn_chance': spawnChance,
      'avg_spawns': avgSpawns,
      'spawn_time': spawnTime,
      'multipliers': multipliers,
      'weaknesses': weaknesses,
      'next_evolution': nextEvolution?.map((x) {
        if (x is EvolutionModel) {
          return x.toJson();
        }
        return {'num': x.numLabel, 'name': x.name};
      }).toList(),
    };
  }
}
