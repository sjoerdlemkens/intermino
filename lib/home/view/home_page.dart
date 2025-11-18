import 'package:flutter/material.dart';
import 'package:fasting_app/home/view/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        onTabSelected: (index) => {},
      ),
      body: Center(
        child: Text("Home"),
      ),
    );
  }
}
