import 'package:flutter/material.dart';

enum PokemonType {
  normal(label: 'Normal', color: Color(0xFFA8A878), icon: Icons.circle),
  fire(
    label: 'Fire',
    color: Color(0xFFF08030),
    icon: Icons.local_fire_department,
  ),
  water(label: 'Water', color: Color(0xFF6890F0), icon: Icons.water_drop),
  grass(label: 'Grass', color: Color(0xFF78C850), icon: Icons.grass),
  electric(label: 'Electric', color: Color(0xFFF8D030), icon: Icons.flash_on),
  ice(label: 'Ice', color: Color(0xFF98D8D8), icon: Icons.ac_unit),
  fighting(label: 'Fighting', color: Color(0xFFC03028), icon: Icons.sports_mma),
  poison(label: 'Poison', color: Color(0xFFA040A0), icon: Icons.science),
  ground(label: 'Ground', color: Color(0xFFE0C068), icon: Icons.terrain),
  flying(label: 'Flying', color: Color(0xFFA890F0), icon: Icons.air),
  psychic(label: 'Psychic', color: Color(0xFFF85888), icon: Icons.psychology),
  bug(label: 'Bug', color: Color(0xFFA8B820), icon: Icons.pest_control),
  rock(label: 'Rock', color: Color(0xFFB8A038), icon: Icons.landscape),
  ghost(label: 'Ghost', color: Color(0xFF705898), icon: Icons.nightlight_round),
  dragon(label: 'Dragon', color: Color(0xFF7038F8), icon: Icons.auto_graph),
  steel(label: 'Steel', color: Color(0xFFB8B8D0), icon: Icons.shield),
  dark(label: 'Dark', color: Color(0xFF705848), icon: Icons.dark_mode),
  fairy(label: 'Fairy', color: Color(0xFFEE99AC), icon: Icons.auto_fix_high);

  final String label;
  final Color color;
  final IconData icon;

  const PokemonType({
    required this.label,
    required this.color,
    required this.icon,
  });

  static PokemonType fromString(String value) {
    return PokemonType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => PokemonType.normal,
    );
  }

  Color get secondaryColor {
    return HSLColor.fromColor(color)
        .withLightness(
          (HSLColor.fromColor(color).lightness - 0.15).clamp(0.0, 1.0),
        )
        .toColor();
  }
}
