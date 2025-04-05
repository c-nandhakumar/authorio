import 'package:authorio/core/utils/log.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/widgets/author_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorListScreen extends StatefulWidget {
  const AuthorListScreen({super.key});

  @override
  AuthorListScreenState createState() => AuthorListScreenState();
}

class AuthorListScreenState extends State<AuthorListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AuthorProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetchMoreIfNeeded(provider); 
    });

    _scrollController =
        ScrollController()..addListener(() {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 150) {
            Log.i("Fetch more data");
            provider.fetchMoreAuthors();
          }
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthorProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: provider.authors.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.authors.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final author = provider.authors[index];
              return AuthorCard(author: author);
            },
          );
        },
      ),
    );
  }

  void _checkAndFetchMoreIfNeeded(AuthorProvider provider) {
  if (_scrollController.hasClients &&
      _scrollController.position.maxScrollExtent <=
          _scrollController.position.viewportDimension &&
      provider.hasMore) {
    Log.i("Viewport not filled, fetching more...");
    provider.fetchMoreAuthors().then((_) {
      // Keep checking recursively until content fills screen or no more items
      _checkAndFetchMoreIfNeeded(provider);
    });
  }
}

}
