import 'package:authorio/core/utils/screen_extensions.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/screens/author_detail_screen.dart';
import 'package:authorio/presentation/style/colors.dart';
import 'package:authorio/presentation/widgets/author_favorite_icon.dart';
import 'package:authorio/presentation/widgets/author_info.dart';
import 'package:authorio/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorCard extends StatefulWidget {
  final AuthorEntity author;
  final VoidCallback onDelete;
  const AuthorCard({required this.author, required this.onDelete, super.key});

  @override
  State<AuthorCard> createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthorProvider>(context);
    final author = widget.author;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              reverseTransitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return AuthorDetailScreen(authorId: author.id);
              },
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },

        child: Container(
          height: 75,
          width: context.screenWidth,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: AuthorInfo(author: author)),
              Row(
                children: [
                  !provider.isSearching
                      ? IconButton(
                        iconSize: 28,
                        icon: AuthorFavoriteIcon(isFavorite: author.isFavorite),
                        onPressed: () => provider.toggleFavorite(author.id),
                      )
                      : SizedBox(),

                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      showDeleteConfirmation(context, author, widget.onDelete);
                    },
                    child: Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
