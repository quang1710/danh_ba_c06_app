

import 'package:danh_ba_c06_app/core/network/server_api_client.dart';
import 'package:danh_ba_c06_app/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:danh_ba_c06_app/features/daily_news/data/models/article.dart';
class NewsApiServiceImpl implements NewsApiService {
  final ServerApiClient serverApi;
  NewsApiServiceImpl({
    required this.serverApi
  });

  @override
  Future<List<ArticleModel>> getNewArticles() async {
    return [];
  }
}