import 'package:flutter/material.dart';

class PokemonListHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  PokemonListHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: height + topPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Column(
        children: [
          if (shrinkOffset > 0) SizedBox(height: topPadding),
          Expanded(
            child: Align(alignment: Alignment.center, child: child),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent =>
      height +
      MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first,
      ).padding.top;

  @override
  double get minExtent =>
      height +
      MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first,
      ).padding.top;

  @override
  bool shouldRebuild(PokemonListHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
