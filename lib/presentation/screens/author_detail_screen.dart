import 'package:authorio/core/utils/screen_extensions.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/style/colors.dart';
import 'package:authorio/presentation/widgets/author_favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class AuthorDetailScreen extends StatefulWidget {
  final int authorId;
  const AuthorDetailScreen({required this.authorId, super.key});

  @override
  State<AuthorDetailScreen> createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthorProvider>(context);
    final author = provider.authors.firstWhere(
      (author) => author.id == widget.authorId,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primary),
              iconSize: 22,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 4),
            Text(
              "Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Spacer(),
            IconButton(
              iconSize: 24,
              icon: AuthorFavoriteIcon(isFavorite: author.isFavorite),
              onPressed: () => provider.toggleFavorite(author.id),
            ),
            SizedBox(width: 24),
          ],
        ),
      ),

      body: GestureDetector(
        onDoubleTap: () {
          provider.toggleFavorite(author.id);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          height: context.screenHeight,
          width: context.screenWidth,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18),
              Hero(
                tag: author.id,
                child: CircleAvatar(
                  radius: 96,
                  backgroundImage: NetworkImage(
                    "${dotenv.get("BASE_URL")}${author.imageUrl}",
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                author.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 24),
              Text(
                author.content,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
