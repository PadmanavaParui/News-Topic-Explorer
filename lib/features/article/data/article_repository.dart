//importing dio
import 'package:dio/dio.dart';
//importing article_model.dart
import 'article_model.dart';

class ArticleRepository {
  //my api key
  final String _apiKey = 'f9a7c9e5747bd767cdc2c259234dd7f6';

  // using Dio for easier API calls
  final Dio _dio = Dio();

  /// Method 1: Getting Top Headlines (For Home Screen)
  /// Fetching news based on a category like 'technology', 'sports', etc.
  /// Returns a list of ArticleModels.
  /// asynchronous function and asynchronous computation cannot provide results immediately when it is started.
  Future<List<ArticleModel>> getTopHeadlines(String category) async {
    const String url = 'https://gnews.io/api/v4/top-headlines';

    try {
      //dynamic response
      final response = await _dio.get(
        url,
        queryParameters: {
          'country': 'us',       // Fetching US news
          'category': category,  // e.g. 'technology'
          'apikey': _apiKey,
          'lang': 'en',
        },
      );

      // _parseResponse - helper method to parse the raw JSON
      return _parseResponse(response);
    } catch (e) {
      // If there is error, printing it to console and returning empty list to prevent crash
      print("Error fetching headlines: $e");
      return [];
    }
  }

  /// Method 2: Searching Articles (For Search Screen)
  /// Fetching news based on a specific keyword query.
  Future<List<ArticleModel>> searchArticles(String query) async {
    const String url = 'https://gnews.io/api/v4/search';

    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'q': query,            // The user's search text
          'apikey': _apiKey,
          'lang': 'en',      // English results only
          'sortby': 'publishedAt',
        },
      );

      return _parseResponse(response);
    } catch (e) {
      print("Error searching articles: $e");
      throw Exception("Failed to search news");
    }
  }

  /// Helper method to parse the raw JSON into a List of ArticleModels
  List<ArticleModel> _parseResponse(Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      if (data['articles'] != null) {
        final List<dynamic> articlesJson = data['articles'];
        // Map each JSON object to our ArticleModel
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }
    }
    return [];
  }
}
