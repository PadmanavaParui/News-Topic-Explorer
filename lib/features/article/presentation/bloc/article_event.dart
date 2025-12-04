part of 'article_bloc.dart'; // Specify that this file is part of article_bloc.dart

abstract class ArticleEvent {} // Define an abstract class for article events

class FetchHeadlines extends ArticleEvent { // Define a specific event for fetching headlines
  final String category; // Declare a final variable for the article category
  FetchHeadlines(this.category); // Constructor to initialize the category
} // End of FetchHeadlines class

class SearchArticles extends ArticleEvent { // Define a specific event for searching articles
  final String query; // Declare a final variable for the search query
  SearchArticles(this.query); // Constructor to initialize the query
} // End of SearchArticles class