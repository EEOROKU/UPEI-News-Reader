import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'news/model/fetcher/Upei_db.dart';

//Example Code Moves between 2 screens
void main() async {
  var client = http.Client();
  var response = await client.get(Uri.parse('https://www.upei.ca/feeds/news.rss'));
  var channel = RssFeed.parse(response.body);
  var news = [];
  var screens = [];
  //await LocalHighScoreDatabase.init();
  //LocalHighScoreDatabase db = LocalHighScoreDatabase();
  //List<HighScoreRecord> records = [];
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

      var secondScreen = SecondScreen(img: imageLink,title: rssItem.title,author: rssItem.dc?.creator??"",date: "${rssItem.pubDate??DateTime.now()}", paper: parsedDescription,);
      news.add(secondScreen);
      /*records.add(HighScoreRecord(rssItem.title, imageLink, rssItem.dc?.creator??"", "${rssItem.pubDate??DateTime.now()}", parsedDescription)); */
    }
  }

  /*db.put(records);
  List<HighScoreRecord> record = db.getLeaders();
  await LocalHighScoreDatabase.close();
  for (var item in record) {
    var secondScreen = SecondScreen(img: item.img,title: item.title,author: item.author,date: '${item.date}', paper: item.paper,);
    news.add(secondScreen);
  }*/
  for (var i = 0; i < news.length; i++){
    var routeName = '/third$i';
    screens.add(routeName);
  }

  runApp(
    MaterialApp(
      onGenerateTitle: (context)=>'Named Routes Demo',
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (context) =>  MyApp(newss: news,screens: screens,),
        for (var i = 0; i < screens.length; i++)
          screens[i]: (BuildContext context) => SecondScreen(img: news[i].img, title: news[i].title, author: news[i].author, date: news[i].date, paper: news[i].paper,),
      },
    ),

  );
}




class MyApp extends StatelessWidget {
  var newss;
  var screens;
  MyApp({Key? key, this.newss, this.screens}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Column(children: [
            Container(height: 100,child: Image.asset('images/UPEI.png', width: 300, height: 250, ),),
            const Text('UPEI News', style: TextStyle(height:0,fontSize: 35,color: Colors.white)),
          ]),
          backgroundColor: Colors.green,
          centerTitle: true,
          toolbarHeight: 200,
        ),
        body: SingleChildScrollView(
          child: Slidable(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List<Widget>.generate(newss.length, (index) {
                return ChoiceTile(
                  img: newss[index].img, text: newss[index].title, page: screens[index],);
              }
            )
        ),
    ),
        ),
    );
  }
}


class SecondScreen extends StatelessWidget {
  final String? img;
  final String? title;
  final String? author;
  final String? date;
  final String? paper;

  const SecondScreen({Key? key, this.img, this.title, this.author, this.date, this.paper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPEI News'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (img != null) Image.network(img!),
              if (title != null) Text(title!, style: const TextStyle(fontSize: 25.0)),
              if (author != null) Text(author!, style: const TextStyle(fontSize: 10.0)),
              if (date != null) Text(date!, style: const TextStyle(fontSize: 10.0)),
              if (paper != null) Text(paper!),
            ],
          ),
        ),
      ),
    );
  }
}




class ChoiceTile extends StatelessWidget {
  var img;
  final String text;
  final String page;
  ChoiceTile({Key? key, required this.img, required this.text, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cardColor = Colors.green[800];

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return InkWell(
            onTap: () {
              setState(() {
                cardColor = Colors.grey;
              });
              Navigator.pushNamed(context, page);
            },
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Container(
                height: 100, // This changes the height of the card
                child: ListTile(
                  leading: Image.network(img, height: 100, width: 100,),
                  title: Text(text, style: TextStyle(fontSize: 14,),),
                  hoverColor: Colors.grey,
                ),
              ),
            ),
          );
        }
    );
  }
}
