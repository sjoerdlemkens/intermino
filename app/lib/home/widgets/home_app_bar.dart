import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/misc/misc.dart';
import 'package:flutter/material.dart';

const homeViewTitles = {
  HomePageView.fast: 'Fasting',
  HomePageView.history: 'History',
  HomePageView.settings: 'Settings',
};

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomePageView? selectedView;
  final String? title;
  final bool showBackButton;

  const HomeAppBar(
    this.selectedView, {
    super.key,
    this.title,
    this.showBackButton = false,
  });

  const HomeAppBar.withTitle(
    this.title, {
    super.key,
    this.selectedView,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String get _title {
    if (title != null) return title!;
    if (selectedView != null) return homeViewTitles[selectedView!]!;
    return '';
  }

  @override
  Widget build(BuildContext context) => CustomAppBar(
        title: _title,
        showBackButton: showBackButton,
      );
}
