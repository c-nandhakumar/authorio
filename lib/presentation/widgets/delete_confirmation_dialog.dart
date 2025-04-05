import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDeleteConfirmation(BuildContext context, int authorId) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text("Delete Author"),
          content: const Text("Are you sure you want to delete this author?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () {
                context.read<AuthorProvider>().deleteAuthor(authorId);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
  );
}
