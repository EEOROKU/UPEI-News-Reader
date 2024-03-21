import 'package:a1_fakenews/news/model/fetcher/fetcher.dart';
import 'package:a1_fakenews/news/model/news_item.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:a1_fakenews/news/model/fetcher/UPEINewsSource.dart';

class MockClient extends Mock implements http.Client {}

class FakeUPEINewsSource extends Fake implements UPEINewsSource {
  final http.Client client;

  FakeUPEINewsSource({required this.client});

  @override
  Future<List<NewsItem>> getNews() async {
    // You can modify this list to include the specific NewsItems you want to use in your tests
    var news = <NewsItem>[
      NewsItem("Test Title 1", "Test Description 1", "Test Author 1", "Test Date 1", "Test Image Link 1", false),
      NewsItem("Test Title 2", "Test Description 2", "Test Author 2", "Test Date 2", "Test Image Link 2", false),
      // Add more NewsItems as needed
    ];
    return news;
  }
}


void main() {
  group('UPEINewsSource', () {
    test('returns news if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the `get` method
      when(client.get(Uri.parse('https://www.upei.ca/feeds/news.rss')))
          .thenAnswer((_) async => http.Response('body', 200));

      expect(await FakeUPEINewsSource(client: client).getNews(), isA<List<NewsItem>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the `get` method
      when(client.get(Uri.parse('https://www.upei.ca/feeds/news.rss')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(FakeUPEINewsSource(client: client).getNews(), throwsException);
    });
  });
}
