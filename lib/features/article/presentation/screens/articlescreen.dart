import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//importing article_model
import '../../data/article_model.dart';

//importing web_view_screen.dart
import 'web_view_screen.dart';


class ArticleScreen extends StatelessWidget {
  //accepting ArticleModel to match the data coming from the ArticleRepository
  final ArticleModel article;

  //constructor
  const ArticleScreen({
    super.key,
    required this.article,
  });

  //overriding the Widget build() function of the parent class
  @override
  Widget build(BuildContext context) {
    // Helper to format the date
    String formattedDate = "Unknown Date";
    // checking of the date is not null
    //if it is not null then we parse the date
    if (article.publishedAt != null) {
      try {
        final DateTime parsedDate = DateTime.parse(article.publishedAt!);
        formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);
      } catch (e) {
        formattedDate = article.publishedAt!;
      }
    }

    // Scaffold
    return Scaffold(
      // using CustomScrollView to handle the scrolling
      body: CustomScrollView(
        // slivers are the widgets that can be scrolled
        // using sliver to make the header scrollable
        slivers: [
          //expandable image header
          SliverAppBar(
            expandedHeight: 300.0,
            //pinned to true to make the header stick
            pinned: true,
            //flexibleSpace to make the image scrollable
            flexibleSpace: FlexibleSpaceBar(
              // backgroundImage to display the image
              background: article.urlToImage != null && article.urlToImage!.isNotEmpty
                  ? Image.network(
                article.urlToImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50)
                    ),
              )
                  : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.article, size: 50),
              ),
            ),
          ),

          //The Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author/Date Row
                  Row(
                    children: [
                      //chip to display the author
                      Chip(
                        //the ArticleModel does not have a source field
                        // so using author instead
                        label: Text(
                          article.author ?? 'News',
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          //overflow to handle the long text
                          overflow: TextOverflow.ellipsis,
                        ),

                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      const Spacer(),
                      //displaying the date
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description (Italicized summary)
                  if (article.description != null) ...[
                    Container(
                      padding: const EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 4
                              )
                          )
                      ),
                      child: Text(
                        article.description!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Main Content
                  Text(
                    article.content ?? 'No further details available.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6, // Better line spacing for reading
                      fontSize: 16,
                    ),
                  ),


                  // Read More Button
                  const SizedBox(height: 30),

                  //checking if the article has a URL before showing the button
                  if(article.url != null && article.url!.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text("Read full article"),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context)=> WebViewScreen(url: article.url!),
                            )
                          );
                        },
                      )
                    ),


                  // Extra space at bottom
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
