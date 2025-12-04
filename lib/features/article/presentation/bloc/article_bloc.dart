import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc package for state management
import '../../data/article_model.dart'; // Import the ArticleModel class
import '../../data/article_repository.dart'; // Import the ArticleRepository class

part 'article_event.dart'; // Include the article_event file
part 'article_state.dart'; // Include the article_state file

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> { // Define the ArticleBloc class extending Bloc
  final ArticleRepository repository; // Declare a final variable for the repository

  ArticleBloc(this.repository) : super(ArticleInitial()) { // Constructor initializing the bloc with the repository and initial state
    on<FetchHeadlines>((event, emit) async { // Register an event handler for FetchHeadlines
      emit(ArticleLoading()); // Emit the loading state
      try { // Start a try block to handle potential errors
        final articles = await repository.getTopHeadlines(event.category); // Fetch top headlines from the repository
        emit(ArticleLoaded(articles)); // Emit the loaded state with the fetched articles
      } catch (e) { // Catch any exceptions that occur
        emit(ArticleError("Failed to fetch headlines")); // Emit the error state with a message
      } // End of try-catch block
    }); // End of FetchHeadlines handler

    on<SearchArticles>((event, emit) async { // Register an event handler for SearchArticles
      emit(ArticleLoading()); // Emit the loading state
      try { // Start a try block to handle potential errors
        final articles = await repository.searchArticles(event.query); // Search for articles using the repository
        emit(ArticleLoaded(articles)); // Emit the loaded state with the search results
      } catch (e) { // Catch any exceptions that occur
        emit(ArticleError("Failed to search articles")); // Emit the error state with a message
      } // End of try-catch block
    }); // End of SearchArticles handler
  } // End of constructor
} // End of ArticleBloc class