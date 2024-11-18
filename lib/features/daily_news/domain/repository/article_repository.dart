import 'package:danh_ba_c06_app/core/resources/data_state.dart';
import 'package:danh_ba_c06_app/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future <DataState<List<ArticleEntity>>> getNewArticles ();
}