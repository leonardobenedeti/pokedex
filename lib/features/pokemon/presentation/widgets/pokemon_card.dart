import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colors_constants.dart';
import '../../domain/entities/pokemon_entity.dart';

class PokemonCard extends StatelessWidget {
  final PokemonEntity pokemon;
  final String searchTerm;
  final VoidCallback onTap;
  final bool isInverse;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    this.searchTerm = '',
    this.isInverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 182,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isInverse ? ColorsConstants.darkBlue : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 86,
                    child: Center(
                      child: Hero(
                        tag: 'pokemon-${pokemon.id}',
                        child: Transform.scale(
                          scale: 1.2, // Zoom in to remove img extra padding
                          child: Image.network(
                            kIsWeb
                                ? 'https://corsproxy.io/?${Uri.encodeComponent(pokemon.img)}'
                                : pokemon.img,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error_outline, size: 40),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildHighlightedName(),
                  const SizedBox(height: 4),
                  Text(
                    '#${pokemon.numLabel}',
                    style: TextStyle(
                      color: isInverse
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isInverse ? Colors.white : ColorsConstants.darkBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: isInverse ? ColorsConstants.darkBlue : Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedName() {
    final String name = pokemon.name;

    final style = TextStyle(
      color: isInverse ? Colors.white : ColorsConstants.darkBlue,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    if (searchTerm.isEmpty ||
        !name.toLowerCase().contains(searchTerm.toLowerCase())) {
      return Text(name, style: style);
    }

    final int startIndex = name.toLowerCase().indexOf(searchTerm.toLowerCase());
    final int endIndex = startIndex + searchTerm.length;

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: name.substring(0, startIndex)),
          TextSpan(
            text: name.substring(startIndex, endIndex),
            style: const TextStyle(color: ColorsConstants.primary),
          ),
          TextSpan(text: name.substring(endIndex)),
        ],
      ),
    );
  }
}
