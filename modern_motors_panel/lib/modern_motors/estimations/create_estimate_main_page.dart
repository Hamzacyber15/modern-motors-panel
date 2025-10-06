import 'package:flutter/material.dart';
import 'package:modern_motors_panel/modern_motors/estimations/create_estimate.dart';

class CreateEstimateMainPage extends StatefulWidget {
  const CreateEstimateMainPage({super.key});

  @override
  State<CreateEstimateMainPage> createState() => _CreateEstimateMainPageState();
}

class _CreateEstimateMainPageState extends State<CreateEstimateMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CreateEstimate(
        key: UniqueKey(),
        onBack: () async {
          if (!mounted) return;
          // setState(() {

          // });
        },
      ),
    );
  }
}
