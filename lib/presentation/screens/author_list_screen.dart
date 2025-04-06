import 'package:authorio/core/utils/log.dart';
import 'package:authorio/core/utils/screen_extensions.dart';
import 'package:authorio/domain/entities/author_entity.dart';
import 'package:authorio/presentation/providers/author_provider.dart';
import 'package:authorio/presentation/style/colors.dart';
import 'package:authorio/presentation/widgets/author_card.dart';
import 'package:authorio/presentation/widgets/loader.dart';
import 'package:authorio/presentation/widgets/retry_error_widget.dart';
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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    final provider = context.read<AuthorProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetchMoreIfNeeded(provider);
    });

    _scrollController =
        ScrollController()..addListener(() {
          // debugPrint(
          //   "ScrollController pixels : ${_scrollController.position.pixels}",
          // );
          if (_scrollController.position.pixels >=
                  _scrollController.position.maxScrollExtent &&
              !provider.isSearching &&
              !provider.isError) {
            Log.i("Fetch more data");
            provider.fetchMoreAuthors().then((newItemsLength) {
              final startIndex = provider.authors.length - newItemsLength;
              _insertAuthors(provider.authors, startIndex);
            });
          }
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _insertAuthors(List<AuthorEntity> authors, int startIndex) {
    for (int i = startIndex; i < authors.length; i++) {
      _listKey.currentState?.insertItem(i);
    }
  }

  void _removeAuthor(AuthorEntity author) {
    final provider = context.read<AuthorProvider>();
    int index = provider.getFullAuthorList.indexWhere((a) => a.id == author.id);
    Log.i("Index removal : $index");
    if (index != -1) {
      context.read<AuthorProvider>().deleteAuthor(author.id);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: AuthorCard(
              author: author,
              key: ValueKey(author.id),
              onDelete: () {},
            ),
          ),
        ),
        duration: Duration(milliseconds: 300),
      );

      final provider = context.read<AuthorProvider>();
      if (!provider.isSearching) {
        _checkAndFetchMoreIfNeeded(provider);
      }
    }
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
                child:
                    provider.isSearching
                        ? ListView.builder(
                          itemCount: provider.authors.length,
                          itemBuilder: (context, index) {
                            final author = provider.authors[index];
                            return AuthorCard(
                              author: author,
                              key: ValueKey(author.id),
                              onDelete: () => _removeAuthor(author),
                            );
                          },
                        )
                        : AnimatedList(
                          key: _listKey,
                          controller: _scrollController,
                          initialItemCount:
                              provider.authors.length +
                              (provider.hasMore && !provider.isSearching
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index, animation) {
                            final isExtraItem =
                                index == provider.authors.length;

                            if (isExtraItem) {
                              if (provider.isError) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: RetryErrorWidget(
                                    errorMessage:
                                        provider.errorMessage ??
                                        "Something went wrong",
                                    onRetryPressed: () {
                                      provider.fetchMoreAuthors().then((
                                        newItemsLength,
                                      ) {
                                        int startIndex =
                                            provider.authors.length -
                                            newItemsLength;
                                        _insertAuthors(
                                          provider.authors,
                                          startIndex,
                                        );
                                      });
                                    },
                                  ),
                                );
                              }

                              return SizeTransition(
                                sizeFactor: animation,
                                child: Loader(),
                              );
                            }

                            final author = provider.authors[index];

                            return SizeTransition(
                              sizeFactor: animation,
                              child: AuthorCard(
                                author: author,
                                key: ValueKey(author.id),
                                onDelete: () => _removeAuthor(author),
                              ),
                            );
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
    final provider = context.watch<AuthorProvider>();
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
            provider.isSearching
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
    // var position = _scrollController.position;
    // Log.i(
    //   "_maxScrollExtent : ${position.maxScrollExtent} || _scrollController.position.viewportDimension : ${position.viewportDimension}",
    // );
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent <=
            _scrollController.position.viewportDimension &&
        provider.hasMore) {
      provider.fetchMoreAuthors().then((newItemsLength) {
        int startIndex = provider.authors.length - newItemsLength;
        _insertAuthors(provider.authors, startIndex);
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
