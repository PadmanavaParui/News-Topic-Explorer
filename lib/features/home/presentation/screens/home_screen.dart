import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// IMPORTS FOR DATA AND SCREENS
import '../../../article/data/article_model.dart';
import '../../../article/data/article_repository.dart';
import '../../../article/presentation/bloc/article_bloc.dart';
import '../../../article/presentation/screens/articlescreen.dart';
import '../../../article/presentation/screens/search_screen.dart';

import 'explore_view.dart';


// THE MAIN CONTAINER (Stateful because it tracks which tab is open)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tracks the current index (0 = Explore, 1 = Feed)
  int _currentIndex = 0;

  // The list of screens to switch between
  final List<Widget> _pages = const [
    TopicGridPage(), // Screen 1
    NewsFeedPage(),  // Screen 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The Body switches based on the index
      body: _pages[_currentIndex],

      // THE BOTTOM NAVIGATION BAR
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Explore', //  Grid View
          ),
          NavigationDestination(
            icon: Icon(Icons.feed),
            label: 'News Feed', // Tab/List View
          ),
        ],
      ),
    );
  }
}

// SCREEN 1: THE TOPIC GRID
class TopicGridPage extends StatelessWidget {
  const TopicGridPage({Key? key}) : super(key: key);

  final List<String> topics = const [
    'Technology', 'Business', 'Sports', 'Health',
    'Science', 'Entertainment', 'General'
  ];

  // Helper to get icons for topics
  IconData _getIconForTopic(String topic) {
    switch (topic) {
      case 'Technology': return Icons.computer;
      case 'Business': return Icons.work;
      case 'Sports': return Icons.sports_soccer;
      case 'Health': return Icons.local_hospital;
      case 'Science': return Icons.science;
      case 'Entertainment': return Icons.movie;
      default: return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Topics"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // --- NAVIGATE TO EXPLORE VIEW ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExploreView(topic: topics[index]),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForTopic(topics[index]),
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      topics[index],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



// SCREEN 2: THE NEWS FEED
class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({super.key});

  // UPDATED: Map display names to API category keys
  final List<Map<String, String>> categories = const [
    {"display": "All", "api": "general"},
    {"display": "Tech", "api": "technology"},
    {"display": "Sports", "api": "sports"},
    {"display": "Biz", "api": "business"},
    {"display": "Health", "api": "health"},
    {"display": "Science", "api": "science"},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daily News"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            tabs: categories.map((cat) => Tab(text: cat['display'])).toList(),
          ),
        ),
        body: TabBarView(
          // Pass the API category key to the NewsList
          children: categories.map((cat) => NewsList(category: cat['api']!)).toList(),
        ),
      ),
    );
  }
}

// Helper Widget for the Feed List (UPDATED to Fetch Data)
class NewsList extends StatelessWidget {
  final String category;
  const NewsList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleBloc(ArticleRepository())..add(FetchHeadlines(category)),
      child: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          // 1. Loading State
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Error State
          if (state is ArticleError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          // 3. Success State
          if (state is ArticleLoaded) {
            if (state.articles.isEmpty) {
              return const Center(child: Text("No articles found."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                return NewsCard(article: state.articles[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Helper Widget for the Individual Card (UPDATED to use ArticleModel)
class NewsCard extends StatelessWidget {
  final ArticleModel article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to ArticleScreen with the real article data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey,
              ),
              child: article.urlToImage != null && article.urlToImage!.isNotEmpty
                  ? ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white));
                  },
                ),
              )
                  : const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.white)),
            ),

            // TEXT SECTION
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author ?? "Unknown Source",
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
