import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  final String image;
  final String title;
  final String body;

  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Image.asset(image)),
        const SizedBox(height: 30.0),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15.0),
        Text(
          body,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
