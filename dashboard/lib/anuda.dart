import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'eventinfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'eventmodel.dart';
import 'apicall.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events and Scheduling',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Events and Scheduling'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFavorited = true;
  var eventData = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    eventData = await getEvents();
    print(eventData);
    setState(() {});
  }

  // create a favorites system for the user to add an event to a favorites
  // list so they can refer back to it or receive notifications for the event
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  // switch case for the filtration for categories
  void handleClick(String value) {
    switch (value) {
      case 'Hacker':
        break;
      case 'Sponsor':
        break;
      case 'Mentor':
        break;
      case 'General':
        break;
    }
  }

  // assigns colors for the categories for filtration of events
  Color getColor(categoryNum) {
    List<Color> colorsList = [
      Colors.redAccent[100],
      Colors.redAccent,
      Colors.redAccent[400],
      Colors.redAccent[700]
    ];
    final colorsMap = colorsList.asMap();
    return colorsMap[categoryNum - 1];
  }

  // symbol and color for each event based on category
  Widget eventIcon(data) {
    return Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.star_border,
                      color: Colors.white,
                      size: 35,
                    ),
                    tooltip: 'Tap to favorite this event!',
                    onPressed: () {
                      setState(() {
                        _toggleFavorite();
                      });
                    })
              ],
            )));
  }

  // name of the event
  Widget eventName(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
          text: '${data.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'TerminalGrotesque'),
        )));
  }

  // description for the event
  Widget eventDescription(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: RichText(
                text: TextSpan(
              text: '\n${data.description}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ))));
  }

  String formatDate(String unixDate) {
    var date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('EEE dd MMM').format(date);
    return formattedDate.toUpperCase();
  }

  String getTime(String unixDate) {
    var date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  // date and time of the event
  Widget eventTime2(data) {
    return Align(
        alignment: Alignment.center,
        child: RichText(
            text: TextSpan(
                text: '${getTime(data.timestamp)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'TerminalGrotesque'),
                children: <TextSpan>[
              TextSpan(
                  text: '\n${formatDate(data.timestamp)}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TerminalGrotesque'))
            ])));
  }

  Widget eventTime(data) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${getTime(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TerminalGrotesque'),
          ),
          Text(
            '${formatDate(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.5,
                fontFamily: 'TerminalGrotesque'),
          ),
        ]);
  }

  // hyperlinked button for the event
  Widget eventLink2(data) {
    return InkWell(
        child: IconButton(
            icon: Icon(
              Icons.videocam,
              color: Colors.white,
              size: 35,
            ),
            tooltip: 'Zoom Link!',

            ),
        onTap: () => launch('${data.zoom_link}'));
  }

  Widget zoomLink(data) {
    return IconButton(
          icon: Icon(
            Icons.videocam,
            color: Colors.white,
            size: 30,
          ),
          tooltip: 'Zoom Link!',
      color: Color.fromARGB(255, 37, 130, 242),
      onPressed: () => launch('${data.zoom_link}')
        );
  }

  Widget calLink(data) {
    return IconButton(
        icon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
          size: 30,
        ),
        tooltip: 'Calendar Link!',
        color: Color.fromARGB(255, 37, 130, 242),
        onPressed: () => launch('${data.zoom_link}')
    );
  }

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'TerminalGrotesque'),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromARGB(255, 37, 130, 242), //blue
          actions: <Widget>[
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched=value;
                  print(isSwitched);
                });
              },
              activeTrackColor: Color.fromARGB(120, 33, 42, 54),
              activeColor: Color.fromARGB(150, 33, 42, 54),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(240, 255, 255, 255), //gray
        body: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      itemCount: eventData.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 220,
                            width: double.maxFinite,
                            child: Card(
                              elevation: 5,
                              //color: getColor(eventData[index].access_code),
                              child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Stack(children: <Widget>[
                                    Align(
                                        alignment: Alignment.center,
                                        child: Stack(children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                width: 100,
                                                height: 220,
                                                color: Color.fromARGB(
                                                    255, 37, 130, 242),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: eventTime(
                                                        eventData[index]))),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: Column(children: <Widget>[
                                                Row(children: <Widget>[
                                                  //eventIcon(eventData[index]),
                                                  eventName(eventData[index]),
                                                ]),
                                                Row(children: <Widget>[
                                                  eventDescription(
                                                      eventData[index]),
                                                ]),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child: RaisedButton(
                                                          color: Color.fromARGB(255, 37, 130, 242),
                                                          child: zoomLink(
                                                              eventData[index]),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        child: RaisedButton(
                                                          color: Color.fromARGB(255, 37, 130, 242),
                                                          child: calLink(
                                                              eventData[index]),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ])),
                                        ]))
                                  ])),
                            ));
                      }))
            ])),
      ),
    );
  }
}