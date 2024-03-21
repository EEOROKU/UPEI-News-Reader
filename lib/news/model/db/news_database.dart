
import '../model.dart';


///Singleton pattern for holding News articles
class NewsDatabase {

  static final NewsDatabase _singleton = NewsDatabase._internal();

  //change the source of the news here
  final NewsSourcer _news = u();

  factory NewsDatabase() {
    return _singleton;
  }

  //private named constructor
  NewsDatabase._internal();

  ///get all of the news items
  Future<List<NewsItem>> getNewsItems() {
    return _news.getNews();
  }
}