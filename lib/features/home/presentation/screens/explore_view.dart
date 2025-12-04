import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../article/data/article_model.dart';
import '../../../article/data/article_repository.dart';
import '../../../article/presentation/bloc/article_bloc.dart';
import '../../../article/presentation/screens/articlescreen.dart';

class ExploreView extends StatelessWidget {
  final String topic;

  const ExploreView({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleBloc(ArticleRepository())..add(FetchHeadlines(topic.toLowerCase())),
      child: Scaffold(
        appBar: AppBar(
          title: Text("$topic News"),
        ),
        body: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) {
            if (state is ArticleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ArticleError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is ArticleLoaded) {
              if (state.articles.isEmpty) {
                return const Center(child: Text("No articles found for this topic."));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return _ExploreNewsCard(article: article);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// A simple internal card widget for this view
class _ExploreNewsCard extends StatelessWidget {
  final ArticleModel article;

  const _ExploreNewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
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
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            article.urlToImage!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 40),
          ),
        )
            : const Icon(Icons.article, size: 40),
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          article.author ?? 'Unknown Source',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
