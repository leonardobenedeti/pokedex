import 'package:flutter/material.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/colors_constants.dart';
import '../../../../core/constants/string_constants.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Image.asset(AssetsConstants.pokeball, width: 32, height: 32),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
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
                                Colors.white.withValues(alpha: .9),
                                Colors.white.withValues(alpha: .0),
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
                                crossAxisAlignment: CrossAxisAlignment.baseline,
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
            ),
          ),
        ],
      ),
    );
  }
}
