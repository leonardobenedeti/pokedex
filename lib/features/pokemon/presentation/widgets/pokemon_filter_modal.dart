import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors_constants.dart';
import '../../../../core/enums/pokemon_type.dart';
import '../cubit/pokemon_cubit.dart';
import '../cubit/pokemon_state.dart';

class PokemonFilterModal extends StatefulWidget {
  const PokemonFilterModal({super.key});

  @override
  State<PokemonFilterModal> createState() => _PokemonFilterModalState();
}

class _PokemonFilterModalState extends State<PokemonFilterModal> {
  late PokemonSortType _sortType;
  late PokemonType? _selectedType;

  @override
  void initState() {
    super.initState();
    final state = context.read<PokemonCubit>().state;
    if (state is PokemonLoaded) {
      _sortType = state.sortType;
      _selectedType = state.selectedType;
    } else {
      _sortType = PokemonSortType.none;
      _selectedType = null;
    }
  }

  void _applyFilters() {
    final cubit = context.read<PokemonCubit>();
    cubit.changeSelectedType(_selectedType);
    cubit.changeSortType(_sortType);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: const [
                  Icon(Icons.tune, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Filtros avancados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _sortType = PokemonSortType.none;
                              _selectedType = null;
                            });
                            context.read<PokemonCubit>().resetFilters();
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorsConstants.primary,
                            side: const BorderSide(
                              color: ColorsConstants.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Limpar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsConstants.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Aplicar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tipo',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PokemonType?>(
                        value: _selectedType,
                        isExpanded: true,
                        hint: const Text('Selecione um tipo'),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Todos'),
                          ),
                          ...PokemonType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(type.icon, color: type.color, size: 20),
                                  const SizedBox(width: 8),
                                  Text(type.label),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ordenar por',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PokemonSortType>(
                        value: _sortType == PokemonSortType.none
                            ? null
                            : _sortType,
                        isExpanded: true,
                        hint: const Text('Selecione a ordenação'),
                        items: const [
                          DropdownMenuItem(
                            value: PokemonSortType.code,
                            child: Text('Código (crescente)'),
                          ),
                          DropdownMenuItem(
                            value: PokemonSortType.alphabetic,
                            child: Text('Alfabética (A-Z)'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortType = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
