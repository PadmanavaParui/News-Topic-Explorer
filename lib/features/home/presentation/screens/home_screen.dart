import 'package:flutter/material.dart';
import '../../../article/presentation/screens/search_screen.dart';


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
                onTap: () {
                  //navigation logic for later
                },
                child: Center(
                  child: Text(
                    topics[index],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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

  final List<String> categories = const [
    "All", "Tech", "Sports", "Biz", "Health", "Science"
  ];

  @override
  Widget build(BuildContext context) {
    // Requires DefaultTabController for the horizontal tabs
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daily News"),

          //search
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
            tabs: categories.map((name) => Tab(text: name)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((category) => const NewsList()).toList(),
        ),
      ),
    );
  }
}

// Helper Widget for the Feed List
class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 10,
      itemBuilder: (context, index) => const NewsCard(),
    );
  }
}

// Helper Widget for the Individual Card
class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("SpaceX Launches Starship", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("By Elon Musk • 2 hours ago", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}