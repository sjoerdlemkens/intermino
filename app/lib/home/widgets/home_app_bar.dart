import 'package:fasting_app/home/home.dart';
import 'package:flutter/material.dart';

const homeViewTitles = {
  HomePageView.fast: 'Fasting',
  HomePageView.history: 'History',
  HomePageView.settings: 'Settings',
};

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomePageView selectedView;
  const HomeAppBar(
    this.selectedView, {
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Color(0xff0f172b),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.25,
              letterSpacing: 0.15,
            ),
        title: Text(
          homeViewTitles[selectedView]!,
        ),
      );
}
