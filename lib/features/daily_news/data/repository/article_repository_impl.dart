import 'package:danh_ba_c06_app/core/resources/data_state.dart';
import 'package:danh_ba_c06_app/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:danh_ba_c06_app/features/daily_news/data/models/article.dart';
import 'package:danh_ba_c06_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:dio/dio.dart';

class ArticleRepositoryImpl implements ArticleRepository {

  final NewsApiService _newsApiService;
  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewArticles() async {
    try{
      final httpResponse = await _newsApiService.getNewArticles();
      return DataSuccess(httpResponse);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions()
        ),
      );
    }
  }
}