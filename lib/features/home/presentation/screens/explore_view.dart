import 'package:flutter/material.dart';
import '../../../article/data/article_model.dart';
import '../../../article/data/article_repository.dart';
import '../../../article/presentation/screens/articlescreen.dart';

class ExploreView extends StatefulWidget {
  final String topic;  const ExploreView({super.key, required this.topic});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  late Future<List<ArticleModel>> _articlesFuture;
  final ArticleRepository _repository = ArticleRepository();

  @override
  void initState() {
    super.initState();
    // Fetch articles based on the topic passed (e.g., 'Technology')
    // We convert the topic to lowercase to match the API requirements if needed,
    // though NewsList logic handles simple strings well.
    _articlesFuture = _repository.getTopHeadlines(widget.topic.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.topic} News"),
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // 3. Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No articles found for this topic."));
          }

          // 4. Success State
          final articles = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _ExploreNewsCard(article: article);
            },
          );
        },
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
