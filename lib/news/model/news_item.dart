import 'package:equatable/equatable.dart';

//Simple class to represent NewsItems
class NewsItem extends Equatable{

  final String? title;
  final String body;
  final String author;
  final String date;

  //has the article been read?
  final bool isRead;

  //image url
  final String image;

  ///construct a news item
  const NewsItem( this.title, this.body, this.author, this.date, this.image, this.isRead);

  ///return a copy of the newsItem but with the read flag set to true
  NewsItem readVersion() {
    return NewsItem(title, body, author, date, image, true);
  }

  //properties involved in the override for == and hashCode
  @override
  List<Object?> get props => [title, body, author, date, isRead];

  //Equatable library convert this object to a string
  @override
  bool get stringify => true;
}