part of 'article_bloc.dart';

abstract class ArticleState {}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<ArticleModel> articles;
  ArticleLoaded(this.articles);
}

class ArticleError extends ArticleState {
  final String message;
  ArticleError(this.message);
}
