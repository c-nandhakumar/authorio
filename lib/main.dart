import 'package:flutter/material.dart';

void main() {
  runApp(const AuthorIO());
}

class AuthorIO extends StatelessWidget {
  const AuthorIO({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Text("Author IO");
      },
    );
  }
}
