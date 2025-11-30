import 'package:flutter/material.dart';

//importing model to understand the data structure
import '../../data/article_model.dart';
//importing the repository to handle API connection
import '../../data/article_repository.dart';


//using stateful widget
// as screen updates and rebuilds when user searches and new data arrives
class SearchScreen extends StatefulWidget {
  // constructor
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  // 1. FORM & CONTROLLERS
  //controllers and keys
  //global key is essential for form validation
  //allows us to chekc if the text field contains valid data
  final _formKey = GlobalKey<FormState>(); // For Validation
  final _searchController = TextEditingController(); // For Input Text

  // 2. STATE VARIABLES
  //listing articlemodel to false
  List<ArticleModel> _articles = [];
  bool _isLoading = false;//initial nothing is loading
  String _statusMessage = "Type a topic to search news";//initial text when nothing is to be searched

  // 3. SEARCH LOGIC
  //performing search
  void _performSearch() async {
    // A. VALIDATION (Requirement 1: Forms + Validation)
    //checking for validation.
    if (_formKey.currentState!.validate()) {

      // Update UI to loading
      //loading when we search something
      //loading symbol to be there
      setState(() {
        _isLoading = true;
        _statusMessage = "Searching...";
      });

      try {
        // B. API CALL (Requirement 2: API Integration)
        final results = await ArticleRepository().searchArticles(_searchController.text);

        setState(() {
          _articles = results;
          _isLoading = false;
          if (results.isEmpty) {
            _statusMessage = "No news found for this topic.";
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _statusMessage = "Error: Could not fetch news.";
        });
      }
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

            // --- SECTION 1: THE FORM ---
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
                      // VALIDATION LOGIC
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a keyword'; // Error message
                        }
                        return null; // Valid
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text("GO"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECTION 2: THE RESULTS (State Management) ---
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _articles.isEmpty
                  ? Center(child: Text(_statusMessage, style: const TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}