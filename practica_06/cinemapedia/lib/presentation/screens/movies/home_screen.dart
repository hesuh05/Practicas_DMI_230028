import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';

  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late final PageController pageController;

  static const viewRoutes = <Widget>[
    HomeView(),
    PopularView(),
    FavoritesView(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex && pageController.hasClients) {
      pageController.animateToPage(
        widget.pageIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: viewRoutes,
          ),
        ),
        bottomNavigationBar: Directionality(
          textDirection: appDirection,
          child: CustomBottomNavigation(currentIndex: widget.pageIndex),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
