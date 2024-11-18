import 'package:danh_ba_c06_app/features/daily_news/data/models/article.dart';

abstract class NewsApiService {
  Future<List<ArticleModel>> getNewArticles();
}