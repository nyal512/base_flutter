import 'package:flutter/material.dart';
import '../../widgets/app_empty_widget.dart';

class EmptyOptionScreen extends StatelessWidget {
  const EmptyOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AppEmptyWidget(
          message: '設定項目なし',
        ),
      ),
    );
  }
}
