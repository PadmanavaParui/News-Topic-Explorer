// 1. IMPORTS
import 'package:flutter/material.dart';

// 2. MAIN CLASS
class HomeScreen2 extends StatelessWidget {
  // Fix for the red line error you faced earlier
  const HomeScreen2({Key? key}) : super(key: key);

  // 3. TABS CONFIGURATION
  // We define the categories exactly as shown in your design.
  final List<String> categories = const [
    "All",
    "Tech",
    "Sports",
    "Biz",
    "Health",
    "Science"
  ];

  @override
  Widget build(BuildContext context) {
    // 4. TAB CONTROLLER
    // DefaultTabController powers the switching logic automatically.
    // 'length' must match the number of items in our 'categories' list.
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(

        // 5. APP BAR
        appBar: AppBar(
          title: const Text("News Topic Explorer"),
          centerTitle: false, // Aligns title to left as per standard Android design
          actions: [
            // The Search Icon on the right
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Placeholder for search action
                print("Search clicked");
              },
            ),
          ],

          // 6. THE TAB BAR (Horizontal Scrollable List)
          bottom: TabBar(
            isScrollable: true, // Allows scrolling if there are many tabs
            // Generate a Tab widget for each string in our list
            tabs: categories.map((String name) => Tab(text: name)).toList(),
          ),
        ),

        // 7. THE BODY (Tab Content)
        // TabBarView switches the visible list when you tap a tab.
        body: TabBarView(
          // We create a ListView for EACH category.
          // (Later, we will filter data based on the category name).
          children: categories.map((String category) {
            return const NewsList(); // Calling our helper widget below
          }).toList(),
        ),
      ),
    );
  }
}

// 8. HELPER WIDGET: THE LIST
// Separating this makes the code cleaner.
class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ListView.builder is efficient for long lists of items.
    return ListView.builder(
      padding: const EdgeInsets.all(12), // Space around the list
      itemCount: 10, // Showing 10 dummy items for now
      itemBuilder: (context, index) {
        // Return the Card Design for each item
        return const NewsCard();
      },
    );
  }
}

// 9. HELPER WIDGET: THE CARD
// This widget draws the specific box design from your ASCII art.
class NewsCard extends StatelessWidget {
  const NewsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Shadow depth
      margin: const EdgeInsets.only(bottom: 16), // Space between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
        children: [

          // A. IMAGE SECTION
          // Using a Container with grey color as a placeholder for now.
          Container(
            height: 180, // Fixed height for the image
            width: double.infinity, // Take full width
            decoration: const BoxDecoration(
              color: Colors.grey, // Grey placeholder color
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.white),
            ),
          ),

          // B. TEXT SECTION
          Padding(
            padding: const EdgeInsets.all(12.0), // Inner spacing for text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "SpaceX Launches Starship",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold, // Bold Title
                  ),
                ),

                const SizedBox(height: 8), // Gap between title and subtitle

                // Subtitle (Author • Time)
                Row(
                  children: const [
                    Text(
                      "By Elon Musk",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(width: 5),
                    Text("•", style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 5),
                    Text(
                      "2 hours ago",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}