import 'package:flutter/material.dart'; // Import Material Design components
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc for state management
import '../../../article/data/article_repository.dart'; // Import the repository to fetch data
import '../bloc/article_bloc.dart'; // Import the ArticleBloc logic
import 'articlescreen.dart'; // Import the screen to display article details

class SearchScreen extends StatelessWidget { // Define the SearchScreen widget
  const SearchScreen({super.key}); // Constructor with key

  @override // Override the build method
  Widget build(BuildContext context) { // Build the UI structure
    // Using a separate BlocProvider for search so it doesn't interfere with the home feed
    return BlocProvider( // Provide the ArticleBloc to the widget tree
      create: (context) => ArticleBloc(ArticleRepository()), // Create a new ArticleBloc instance
      child: const SearchView(), // Display the SearchView widget
    ); // End BlocProvider
  } // End build
} // End SearchScreen

class SearchView extends StatefulWidget { // Define the SearchView stateful widget
  const SearchView({super.key}); // Constructor with key

  @override // Override createState
  State<SearchView> createState() => _SearchViewState(); // Create the state for SearchView
} // End SearchView

class _SearchViewState extends State<SearchView> { // State class for SearchView
  final _formKey = GlobalKey<FormState>(); // Key for the form validation
  final _searchController = TextEditingController(); // Controller for the text input

  void _performSearch(BuildContext context) { // Method to handle search action
    if (_formKey.currentState!.validate()) { // Check if the input is valid
      // Trigger the Bloc event
      context.read<ArticleBloc>().add(SearchArticles(_searchController.text)); // Dispatch SearchArticles event
    } // End if
  } // End _performSearch

  @override // Override build
  Widget build(BuildContext context) { // Build the UI
    return Scaffold( // Basic layout structure
      appBar: AppBar(title: const Text("Search News")), // App bar with title
      body: Padding( // Add padding around the body
        padding: const EdgeInsets.all(16.0), // Set padding to 16 pixels
        child: Column( // Arrange children vertically
          children: [ // List of children widgets
            // --- SEARCH FORM ---
            Form( // Form widget for validation
              key: _formKey, // Assign the form key
              child: Row( // Arrange input and button horizontally
                children: [ // List of children in the row
                  Expanded( // Make the text field take available space
                    child: TextFormField( // Text input field
                      controller: _searchController, // Assign the controller
                      decoration: const InputDecoration( // Style the input
                        labelText: "Search Topic (e.g. Bitcoin)", // Placeholder label
                        border: OutlineInputBorder(), // Outline border style
                        prefixIcon: Icon(Icons.search), // Search icon prefix
                      ), // End decoration
                      validator: (value) { // Validation logic
                        if (value == null || value.trim().isEmpty) { // Check if empty
                          return 'Please enter a keyword'; // Error message
                        } // End if
                        return null; // Return null if valid
                      }, // End validator
                    ), // End TextFormField
                  ), // End Expanded
                  const SizedBox(width: 10), // Add spacing between field and button
                  ElevatedButton( // Button to trigger search
                    onPressed: () => _performSearch(context), // Call search method on press
                    style: ElevatedButton.styleFrom( // Custom style for button
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding inside button
                    ), // End styleFrom
                    child: const Text("GO"), // Button label
                  ), // End ElevatedButton
                ], // End children
              ), // End Row
            ), // End Form
            const SizedBox(height: 20), // Add vertical spacing

            // --- SEARCH RESULTS (BLoC Builder) ---
            Expanded( // Make the results take remaining space
              child: BlocBuilder<ArticleBloc, ArticleState>( // Listen to bloc state changes
                builder: (context, state) { // Build UI based on state
                  if (state is ArticleInitial) { // Check if initial state
                    return const Center( // Center the text
                      child: Text("Type a topic to search news", style: TextStyle(color: Colors.grey, fontSize: 16)), // Prompt text
                    ); // End Center
                  } else if (state is ArticleLoading) { // Check if loading state
                    return const Center(child: CircularProgressIndicator()); // Show loader
                  } else if (state is ArticleError) { // Check if error state
                    return Center(child: Text("Error: ${state.message}")); // Show error message
                  } else if (state is ArticleLoaded) { // Check if loaded state
                    if (state.articles.isEmpty) { // Check if list is empty
                      return const Center(child: Text("No news found for this topic.")); // Show empty message
                    } // End if
                    return ListView.builder( // Build a list of items
                      itemCount: state.articles.length, // Number of items
                      itemBuilder: (context, index) { // Builder for each item
                        final article = state.articles[index]; // Get article at index
                        return Card( // Card widget for each item
                          margin: const EdgeInsets.only(bottom: 12), // Margin at bottom
                          elevation: 2, // Shadow elevation
                          child: ListTile( // Standard list tile
                            contentPadding: const EdgeInsets.all(10), // Padding inside tile
                            onTap: () { // Handle tap event
                              Navigator.push( // Navigate to details screen
                                context, // Current context
                                MaterialPageRoute( // Route transition
                                  builder: (context) => ArticleScreen(article: article), // Destination screen
                                ), // End MaterialPageRoute
                              ); // End Navigator.push
                            }, // End onTap
                            leading: article.urlToImage != null // Check if image exists
                                ? Image.network( // Load network image
                              article.urlToImage!, // Image URL
                              width: 80, // Image width
                              fit: BoxFit.cover, // Cover the box
                              errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50), // Fallback icon
                            ) // End Image.network
                                : const Icon(Icons.article, size: 50), // Default icon if no image
                            title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis), // Article title
                            subtitle: Text(article.publishedAt ?? "", style: const TextStyle(fontSize: 12)), // Article date
                          ), // End ListTile
                        ); // End Card
                      }, // End itemBuilder
                    ); // End ListView.builder
                  } // End if ArticleLoaded
                  return const SizedBox.shrink(); // Default empty widget
                }, // End builder
              ), // End BlocBuilder
            ), // End Expanded
          ], // End children
        ), // End Column
      ), // End Padding
    ); // End Scaffold
  } // End build
} // End _SearchViewState