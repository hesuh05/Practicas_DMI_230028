import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  static const viewRoutes = <Widget>[HomeView(), SizedBox(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    final appDirection = Directionality.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: Directionality(
          textDirection: appDirection,
          child: const AppDrawer(),
        ),
        body: Directionality(
          textDirection: appDirection,
          child: IndexedStack(
            index: pageIndex.clamp(0, viewRoutes.length - 1).toInt(),
            children: viewRoutes,
          ),
        ),
        bottomNavigationBar: Directionality(
          textDirection: appDirection,
          child: CustomBottomNavigation(currentIndex: pageIndex),
        ),
      ),
    );
  }
}
