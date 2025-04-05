import 'package:authorio/core/utils/screen_extensions.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/style/colors.dart';
import 'package:authorio/presentation/widgets/author_info.dart';
import 'package:authorio/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorCard extends StatefulWidget {
  final AuthorEntity author;
  const AuthorCard({required this.author, super.key});

  @override
  State<AuthorCard> createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthorProvider>(context);
    final author = widget.author;
    return Container(
      height: 75,
      width: context.screenWidth,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AuthorInfo(author: author),
          Spacer(),
          !provider.isSearching
              ? IconButton(
                icon: Icon(
                  author.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_rounded,
                  color: author.isFavorite ? Colors.red : AppColors.secondary,
                ),
                onPressed: () => provider.toggleFavorite(author.id),
              )
              : SizedBox(),
          SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              showDeleteConfirmation(context, author);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
