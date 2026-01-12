import '../../domain/entities/evolution_entity.dart';

class EvolutionModel extends EvolutionEntity {
  const EvolutionModel({required super.numLabel, required super.name});

  factory EvolutionModel.fromJson(Map<String, dynamic> json) {
    return EvolutionModel(numLabel: json['num'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'num': numLabel, 'name': name};
  }
}
