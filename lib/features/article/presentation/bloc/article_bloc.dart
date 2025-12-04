import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/article_model.dart';
import '../../data/article_repository.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository repository;

  ArticleBloc(this.repository) : super(ArticleInitial()) {
    on<FetchHeadlines>((event, emit) async {
      emit(ArticleLoading());
      try {
        final articles = await repository.getTopHeadlines(event.category);
        emit(ArticleLoaded(articles));
      } catch (e) {
        emit(ArticleError("Failed to fetch headlines"));
      }
    });

    on<SearchArticles>((event, emit) async {
      emit(ArticleLoading());
      try {
        final articles = await repository.searchArticles(event.query);
        emit(ArticleLoaded(articles));
      } catch (e) {
        emit(ArticleError("Failed to search articles"));
      }
    });
  }
}
