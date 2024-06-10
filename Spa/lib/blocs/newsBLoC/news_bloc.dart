import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbdd/blocs/newsBLoC/news_event.dart';
import 'package:tbdd/blocs/newsBLoC/news_state.dart';
import 'package:tbdd/repositories/NewsRepository.dart';

import '../../Models/News.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository = NewsRepository();

  NewsBloc() : super(NewsInitialState()) {
    on<NewsEventLoad>((event, emit) async {
      emit(NewsLoadingState());
      List<News> highlishNews = await getHighlighNews();
      List<News> allNews = await getAllNews();
      List<News> favoriteNews = await getFavoriteNews();
      emit(NewsLoadedState(
          listAllNews: allNews,
          listHighlighNews: highlishNews,
          listFavoriteNews: favoriteNews));
    });
    on<EventFavoriteNews>((event, emit) async {
      if (event.news.Favorite == false) {
        await _newsRepository.createFavoriteNews(event.news);
      } else {
        await _newsRepository.deleteFavoriteNews(event.news);
      }
      List<News> highlishNews = await getHighlighNews();
      List<News> allNews = await getAllNews();
      List<News> favoriteNews = await getFavoriteNews();
      emit(NewsLoadedState(
          listAllNews: allNews,
          listHighlighNews: highlishNews,
          listFavoriteNews: favoriteNews));
    });
  }

  Future<List<News>> getAllNews() async {
    return await _newsRepository.getAllNews();
  }

  Future<List<News>> getHighlighNews() async {
    return await _newsRepository.getHighlighNews();
  }

  Future<List<News>> getFavoriteNews() async {
    return await _newsRepository.getListFavoritesNews();
  }
}
