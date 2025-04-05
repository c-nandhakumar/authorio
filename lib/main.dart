import 'package:authorio/domain/repositories/author_repository.dart';
import 'package:authorio/locator.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/screens/author_list_screen.dart';
import 'package:authorio/presentation/style/colors.dart';
import 'package:authorio/presentation/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  initializeDependencies();
  runApp(const AuthorIO());
}

class AuthorIO extends StatelessWidget {
  const AuthorIO({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) =>
                  AuthorProvider(repository: locator<AuthorRepository>()),
        ),
      ],
      child: MaterialApp(
        title: "AuthorIO",
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: fontFamily,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              foregroundColor: Colors.black,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 2, color: AppColors.primary),
              minimumSize: const Size(0, 0),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              textStyle: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: AuthorListScreen(),
      ),
    );
  }
}
