import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'news/model/fetcher/UPEINewsSource.dart';
import 'package:http/http.dart' as http;
import 'package:a1_fakenews/news/model/fetcher/fetcher.dart';

//Example Code Moves between 2 screens
void main() async {
  var client = http.Client();
  var gen = UPEINewsSource(client: client);
  var newsI = await gen.getNews();
  var news = [];
  var screens = [];
  for (var item in newsI) {
    var secondScreen = SecondScreen(img: item.image,title: item.title,author: item.author,date: '${item.date}', paper: item.body,);
    news.add(secondScreen);
  }
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
          return Slidable(

            key: const ValueKey(0),

            // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: const [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: print ,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: print,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: const ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: print,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: print,
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),

            child: InkWell(
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
          ),
          );
        }
    );
  }
}
