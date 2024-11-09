import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/core/widget/boundary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InterceptorBoundary(
      canPop: false,
      child: Scaffold(
        body: Placeholder(),
      ),
    );
  }
}
