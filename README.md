# A2 UPEI News Reader

**Deadline: March 11, 4pm**

In this assignment we pick up where we left off on assignment 1 and convert the fake news reader into a UPEI news reader.

![example app](resources/example.png)

*Note: the sample solution from assignment 1 is posted to moodle, so you can pick up from that point if you want. You are however, encouraged to continue with your efforts from assignment 1.*

# Requirements:

Your app must include the following:

1. Declarative style routing
2. Tracking of articles that have been read
  - this should persist when the app is reopened after closing
3. read later feature for offline reading of articles that have been selected by the user
4. no frozen screens while data is loading
5. avoid excessive loading
  - don't re-fetch pictures for articles that have already been loaded for example
6. A `UPEINewsSource` class that extends `NewsSourcer`
7. tests that Mock the `http.Client` to test your `UPEINewsSource` code
8. a continued focus on separation between the UI and the Data (state management)

## How to get the Data

The data will come from the UPEI RSS News Feed:

https://www.upei.ca/feeds/news.rss

You can parse the data fairly easily using an RSS Parser like:

https://pub.dev/packages/webfeed

### Example:

```dart
//import
import 'package:webfeed/webfeed.dart';

//....


//response is what you get back from an http.get call
RssFeed feed = RssFeed.parse(response.body);
for(RssItem rssItem in feed.items??<RssItem>[]) {

      //news article title
      print(rssItem.title??"");

      //raw story with some html formatting in it
      print(rssItem.description??"");

      //author
      print(rssItem.dc?.creator??"");

      //date
      print(rssItem.pubDate??DateTime.now());

      //story url (where we can get the picture from)
      print("link ${rssItem.link}");

}
```

Obtaining the picture isn't trivial. It is embedded in the html that goes with the story (from the .link) above.

I've used the html (https://pub.dev/packages/html) package but regex or other string parsing (e.g. xpath or manual) could work as well. You are free to use this code in your assignment however.

```dart

//some imports
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

// ...

final response = await client.get(Uri.parse(link));

if(response.statusCode == 200) {
  var document = parse(response.body);
  dom.Element? link = document.getElementsByClassName("medialandscape")[0]
                      .querySelector('img');
  String imageLink = link != null ? link.attributes['src']??"" : "";
  imageLink = "https://upei.ca/"+imageLink;
}
```

If you want to get rid of those html tags inside the rss description the following might help (again using that html package from above):

```dart
final document = parse(description);
final String parsedDescription = parse(document.body?.text).documentElement?.text??"";
```

You might have to make some adjustments for null safety or error handling in the above. But it will certainly get you started.

## Grading

Code Readability: 1 pts

- comments at the top of each method and class
- appropriate variable names

State Management: 2 pts

- separation of the frontend and backend
- adherence to the single responsibility principle

Functionality: 4 pts

- ability to save articles for offline reading
- persistence of indication of which articles have been read

*how to save the articles and persist the read indication is left to you, whether it is hive or sql-lite or other local storage options.*

Options for the offline reading:
- you use an icon like the bookmark icon or slideable (https://www.youtube.com/watch?v=QFcFEpFmNJ8&ab_channel=Flutter), etc or some sort of button or heart whatever you like.

- You will need a new page (potentially) and navigation / route that allows the user to enter the offline reading list.

  - again this is left to you maybe a tab pane, or drawer or like our quiz game some poor looking buttons that route to the offline or online article list.

Mocked Test: 2 pts

- you must mock the http.client and test your `UPEINewsSource` class.

- 2 or 3 tests for errors or missing data or good responses with valid data will suffice.

- it might improve testing if your `UPEINewsSource` takes in the constructor an `http.Client`:

```dart
//example constructor declaration
UPEINewsSource({client}): this.client = client??http.Client();
```

Above and Beyond: 1 pt

- add something that isn't listed above.
- showcase your skills or have fun finding some new widget / creating your own


Total: 10 pts


# Submission

- add your android studio project as a folder titled A2 to this repository and push to Github before the deadline.

Your directory structure should be as follows, where A2 is your android studio project containing your solution app:

```ascii  
repository_base
 |
 ---README.md
 ---resources/
 ---A2/
```
