import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../article/data/article_repository.dart';
import '../bloc/article_bloc.dart';
import 'articlescreen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a separate BlocProvider for search so it doesn't interfere with the home feed
    return BlocProvider(
      create: (context) => ArticleBloc(ArticleRepository()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  void _performSearch(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Trigger the Bloc event
      context.read<ArticleBloc>().add(SearchArticles(_searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search News")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SEARCH FORM ---
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: "Search Topic (e.g. Bitcoin)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a keyword';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _performSearch(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text("GO"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- SEARCH RESULTS (BLoC Builder) ---
            Expanded(
              child: BlocBuilder<ArticleBloc, ArticleState>(
                builder: (context, state) {
                  if (state is ArticleInitial) {
                    return const Center(
                      child: Text("Type a topic to search news", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    );
                  } else if (state is ArticleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ArticleError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is ArticleLoaded) {
                    if (state.articles.isEmpty) {
                      return const Center(child: Text("No news found for this topic."));
                    }
                    return ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleScreen(article: article),
                                ),
                              );
                            },
                            leading: article.urlToImage != null
                                ? Image.network(
                              article.urlToImage!,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50),
                            )
                                : const Icon(Icons.article, size: 50),
                            title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                            subtitle: Text(article.publishedAt ?? "", style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
