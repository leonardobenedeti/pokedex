import 'package:flutter/material.dart';

class PokemonTypeLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isFilled;

  const PokemonTypeLabel({
    super.key,
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          if (isFilled)
            Positioned.fill(
              child: Center(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(right: isFilled ? 12 : 0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isFilled ? Colors.white : secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
