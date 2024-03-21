import 'package:a1_fakenews/news/model/fetcher/fetcher.dart';
import 'package:a1_fakenews/news/model/news_item.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class UPEINewsSource extends NewsSourcer{
  final http.Client client;

  UPEINewsSource({required this.client});

  @override
  Future<List<NewsItem>> getNews() async{
    var response = await client.get(Uri.parse('https://www.upei.ca/feeds/news.rss'));
    var channel = RssFeed.parse(response.body);
    var news = <NewsItem>[];
    for(RssItem rssItem in channel.items??<RssItem>[]) {
      final responses = await client.get(Uri.parse('${rssItem.link}'));

      if(responses.statusCode == 200) {
        var document = parse(responses.body);
        dom.Element? link = document.getElementsByClassName("medialandscape")[0]
            .querySelector('img');
        String imageLink = link != null ? link.attributes['src']??"" : "";
        imageLink = "https://upei.ca/"+imageLink;
        final doc = parse(rssItem.description);
        final String parsedDescription = parse(doc.body?.text).documentElement?.text??"";

        var secondScreen = NewsItem(rssItem.title, parsedDescription, rssItem.dc?.creator??"", "${rssItem.pubDate??DateTime.now()}", imageLink, false);
        news.add(secondScreen);
      }
    }
    return news;
  }
}
