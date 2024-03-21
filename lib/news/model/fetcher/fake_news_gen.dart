//Fake News Generator
import 'package:a1_fakenews/news/model/news_item.dart';
import 'package:faker_dart/faker_dart.dart';
import 'news_gen.dart';

///generate fake news stories
class FakeNewsGenerator implements NewsSourcer {

  final faker = Faker.instance;

  //retrieve up to 30 fake news items
  @override
  Future<List<NewsItem>> getNews() async{
    var news = <NewsItem> [];
    //how many news items to generate
    var number = 30;

    //stories from the last X years
    DateTime early = faker.date.past(DateTime.now(), rangeInYears:10);
    print(early);
    for (var i = 0; i < number; i++) {
      late NewsItem newsItem;
      try {
        newsItem = _genNewsItem(early);
      } catch(e) {
        print(e);
        newsItem = _genDefault();
      }
      news.add(newsItem);
    }
    //custom sort the news by date
    news.sort((a,b)=>a.date.compareTo(b.date));
    return news;
  }

  ///generate a news item between now and the earliest date
  NewsItem _genNewsItem(DateTime earliest) {
    String author = faker.name.fullName();
    String title = faker.company.catchPhrase();
    String body = faker.lorem.paragraph(sentenceCount: 10);
    //date from the prior year
    DateTime date = faker.date.past(DateTime.now(), rangeInYears:10);
    int seed = DateTime.now().millisecond + DateTime.now().microsecond;
    var image = faker.image.loremPicsum.image(width:300,height:200, seed:'$seed');

    return NewsItem(title, body, author, date, image, false);
  }

  NewsItem _genDefault() {
    return NewsItem("A", "B", "C", DateTime.now(),"https://i.picsum.photos/id/930/300/200.jpg", false);
  }
}