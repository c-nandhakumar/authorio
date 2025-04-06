import 'package:authorio/core/utils/log.dart';
import 'package:authorio/core/utils/screen_extensions.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/style/colors.dart';
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
  final TextEditingController _searchController = TextEditingController();

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
                  _scrollController.position.maxScrollExtent - 100 &&
              !provider.isSearching &&
              !provider.isError) {
            Log.i("Fetch more data");
            provider.fetchMoreAuthors();
          }
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        toolbarHeight: 84,
        title: PreferredSize(
          preferredSize: const Size.fromHeight(84),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: _buildSearchBar(context),
          ),
        ),
      ),
      body: Consumer<AuthorProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              provider.isSearching
                  ? PreferredSize(
                    preferredSize: const Size.fromHeight(36),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Search Results",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            "${provider.authors.length} ${provider.authors.length > 1 ? "founds" : "found"}",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : SizedBox(),
              Expanded(
                child: ListView.builder(
                  // shrinkWrap: true,
                  controller: _scrollController,
                  itemCount:
                      provider.authors.length +
                      (provider.hasMore && !provider.isSearching ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.authors.length) {
                      if (provider.isError) {
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Image.asset("assets/images/dinobanner.jpg"),
                              SizedBox(height: 8),
                              Text(
                                "${provider.errorMessage}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () {
                                  provider.fetchMoreAuthors();
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      }
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final author = provider.authors[index];
                    return AuthorCard(author: author, key: ValueKey(author.id));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final provider = context.read<AuthorProvider>();
    return TextField(
      controller: _searchController,
      onChanged: (query) {
        if (query.trim().isNotEmpty) {
          provider.search(query.trim());
        } else {
          provider.clearSearch();
        }
      },
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black.withValues(alpha: 0.65),
        ),
        hintText: "Search...",
        suffixIcon:
            _searchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    provider.clearSearch();
                    FocusScope.of(context).unfocus();
                  },
                )
                : const Icon(Icons.search),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(48),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary, width: 1.5),
          borderRadius: BorderRadius.circular(48),
        ),
        fillColor: AppColors.secondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }

  void _checkAndFetchMoreIfNeeded(AuthorProvider provider) {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent <=
            _scrollController.position.viewportDimension &&
        provider.hasMore) {
      Log.d(
        "Viewport not filled, fetching more... ${_scrollController.position.maxScrollExtent} -- ${_scrollController.position.viewportDimension}",
      );

      provider.fetchMoreAuthors().then((_) {
        final size = provider.authors.length;
        if (mounted) {
          Log.i(
            "authors list size : $size - ${size * 75} - ${context.screenHeight}",
          );
          //Checking with the screen height in order to fetch the data
          if ((size * 75) < context.screenHeight && !provider.isError) {
            _checkAndFetchMoreIfNeeded(provider);
          }
        }
      });
    }
  }
}
