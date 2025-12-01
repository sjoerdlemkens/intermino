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
        title: Text(
          homeViewTitles[selectedView]!,
        ),
      );
}
