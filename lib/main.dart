import 'package:authorio/domain/repositories/author_repository.dart';
import 'package:authorio/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  initializeDependencies();
  var repo = locator<AuthorRepository>();
  var result = await repo.fetchAuthors();
  print("Result : ${result.toString()}");
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
