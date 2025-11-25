import 'package:flutter/material.dart';

class BrandSplashView extends StatelessWidget {
  const BrandSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.list_alt,
          size: 100,
          color: Colors.white,
        ),
        const SizedBox(height: 24),
        Text(
          'ListFlutter',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 48),
        CircularProgressIndicator(
          color: Colors.white,
        ),
      ],
    );
  }
}
