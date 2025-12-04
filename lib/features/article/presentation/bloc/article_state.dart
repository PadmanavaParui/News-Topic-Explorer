part of 'article_bloc.dart'; // Specify that this file is part of article_bloc.dart

abstract class ArticleState {} // Define an abstract class for article states

class ArticleInitial extends ArticleState {} // Define the initial state of the article bloc

class ArticleLoading extends ArticleState {} // Define the loading state indicating data is being fetched

class ArticleLoaded extends ArticleState { // Define the loaded state containing the list of articles
  final List<ArticleModel> articles; // Declare a final variable for the list of articles
  ArticleLoaded(this.articles); // Constructor to initialize the articles list
} // End of ArticleLoaded class

class ArticleError extends ArticleState { // Define the error state containing an error message
  final String message; // Declare a final variable for the error message
  ArticleError(this.message); // Constructor to initialize the error message
} // End of ArticleError class