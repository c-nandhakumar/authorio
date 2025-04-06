import 'package:flutter/material.dart';

class RetryErrorWidget extends StatelessWidget {
  final VoidCallback onRetryPressed;
  final String errorMessage;
  const RetryErrorWidget({
    required this.errorMessage,
    required this.onRetryPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Image.asset("assets/images/dinobanner.jpg"),
        SizedBox(height: 8),
        Text(
          errorMessage,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        OutlinedButton(
          onPressed: onRetryPressed,
          child: const Text("Retry"),
        ),
      ],
    );
  }
}
