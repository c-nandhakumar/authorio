import 'package:authorio/domain/entities/author_entity.dart';
import 'package:authorio/presentation/style/colors.dart';
import 'package:authorio/presentation/style/text.dart';
import 'package:authorio/presentation/widgets/author_info.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmation(
  BuildContext context,
  AuthorEntity author,
  VoidCallback onDelete,
) {
  showDialog(
    context: context,
    builder:
        (_) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            constraints: BoxConstraints(maxWidth: 360, maxHeight: 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delete this author?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 12),
                  child: Container(
                    padding: EdgeInsets.only(top: 12, bottom: 4),
                    height: 64,
                    child: AuthorInfo(author: author),
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 16,
                            height: 1.25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      SizedBox(width: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 3, color: AppColors.primary),
                          minimumSize: const Size(0, 0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          textStyle: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 18,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          onDelete();
                          Navigator.pop(context);
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
