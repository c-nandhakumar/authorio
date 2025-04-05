import 'package:authorio/core/utils/date_formatter.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthorInfo extends StatelessWidget {
  final AuthorEntity author;
  const AuthorInfo({required this.author, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: author.id,
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              "${dotenv.get("BASE_URL")}${author.imageUrl}",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                timeAgo(author.updated),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
