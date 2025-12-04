part of 'article_bloc.dart';

abstract class ArticleEvent {}

class FetchHeadlines extends ArticleEvent {
  final String category;
  FetchHeadlines(this.category);
}

class SearchArticles extends ArticleEvent {
  final String query;
  SearchArticles(this.query);
}
