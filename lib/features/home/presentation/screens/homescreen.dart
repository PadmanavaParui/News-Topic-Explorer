//IMPORTS
import 'package:flutter/material.dart';
//importing the ArticleScreen so we can navigate to it when a user taps a topic.
import '../../../article/presentation/screens/articlescreen.dart';

//STATELESS WIDGET
// The Home Screen doesn't need to change its own look dynamically (no counters or text inputs),
// using a StatelessWidget.
class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  //TOPIC DATA
  //simple list of strings representing the news categories we want to show.
  // We make it 'final' because this list won't change while the app runs.
  final List<String> topics = const [
    'Technology',
    'Business',
    'Sports',
    'Health',
    'Science',
    'Entertainment',
    'General',
  ];

  //ICON HELPER
  // icon helper function to pick an icon based on the topic name.
  // making the UI look richer than just text.
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

  //BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // Scaffold to provide the basic white background and structure.
    return Scaffold(
      // Top App Bar
      appBar: AppBar(
        title: const Text("News Explorer"), // Title text
        centerTitle: true, // Centering the title
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Using theme color
      ),

      // The Body
      //stacking widgets vertically using column
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligning text to the left
        children: [

          // SECTION HEADER
          const Padding(
            padding: EdgeInsets.all(16.0), // Adding space around the text
            child: Text(
              "Explore by Category",
              style: TextStyle(
                fontSize: 22, // Large text
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ),

          // THE GRID
          // Expanded to make the GridView take up all remaining vertical space.
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16), // Padding around the whole grid

              // controlling the layout: 2 columns, with spacing between items.
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 16, // Horizontal space between cards
                mainAxisSpacing: 16, // Vertical space between cards
                childAspectRatio: 1.1, // Makes cards slightly wider than they are tall
              ),

              // Telling the builder how many items to create (length of our topics list).
              itemCount: topics.length,

              // item builder to build each individual card.
              itemBuilder: (context, index) {
                // Getting the specific topic string for this index
                final topic = topics[index];

                // Returning a Card widget for a nice shadow effect.
                return Card(
                  elevation: 4, // adding depth of shadow using elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounding the corners
                  ),

                  // InkWell to add the "ripple" effect when you tap the card.
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      //NAVIGATION LOGIC
                      //When tapped, pushing the ArticleScreen onto the stack.
                      //passing the 'topic' variable to the next screen later!
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArticleScreen(),
                        ),
                      );
                    },

                    // The content inside the card
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centering vertically
                      children: [
                        // Displaying the icon
                        Icon(
                          _getIconForTopic(topic),
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 10), // Space between icon and text
                        // Displaying the text
                        Text(
                          topic,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}