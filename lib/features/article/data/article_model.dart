class ArticleModel {
  final String title;
  final String? description;
  final String? urlToImage;
  final String? author;
  final String? publishedAt;
  final String? content;
  final String? url;

  ArticleModel({
    required this.title,
    this.description,
    this.urlToImage,
    this.author,
    this.publishedAt,
    this.content,
    this.url,
  });

  // Factory constructor to create an Article from JSON data
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      // Sometimes title is null, so we provide a default string
      title: json['title'] ?? "No Title Available",

      description: json['description'],

      // NewsAPI sometimes sends broken image URLs, so we keep it nullable
      urlToImage: json['urlToImage'],

      author: json['author'] ?? "Unknown Source",

      // Date formatting can be done in the UI later
      publishedAt: json['publishedAt'],

      content: json['content'],

      //mapping the json url to our model field
      url: json['url']
    );
  }
}