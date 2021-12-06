import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:share/share.dart';
import 'package:thulo_event/event_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database/db_helper.dart';
import './models/event.dart';
import './add_event.dart';
import './models/detail.dart';
import 'dart:async';

// import 'package:sqflite/sqflite.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  DbHelper dbHelper = DbHelper();
  late List<Event> eventList;
  late List<Detail> detailList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset("assets/company.png", height: 35, width: 40,),
            SizedBox(width: 2,),
            Text('Thulo Event App',)
          ],
        ),
        actions: <Widget>[
        Text(' '),
        SizedBox(width: 3,),
         IconButton(
           icon: Icon(Icons.help_outline),
           onPressed: (){
            _showAbout("About Thulo Event App", "Develop By: Thulo Technology Pvt.Ltd. \nEmail: info@thulotechnology.com\nMade In Nepal", context);
           },
         )
        ],
      ), 
      bottomNavigationBar: BottomAppBar(
         color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(height: 50,),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          height: 60.0,
        width: 60.0,
        child: FloatingActionButton(
        
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
           onPressed: () async {
            var nav = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEvent(
                    Event(), 'Add Event'),
                ));
          setState(() {
                  getListView();
          dbHelper.getEventList();
          });
          },
          
        
        ),
      ),
      body: getListView(),
    );
  }

  FutureBuilder<dynamic> getListView() {
    return FutureBuilder(
      future: dbHelper.getEventList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          eventList = snapshot.data;
          int len = snapshot.data.length;
          return   len == 0? Container(
                              alignment: AlignmentDirectional.center,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.blueAccent
                                                      .withOpacity(0.7),
                                                  Theme.of(context)
                                                      .focusColor
                                                      .withOpacity(0.05),
                                                ])),
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          size: 70,
                                        ),
                                      ),
                                      Positioned(
                                        right: -30,
                                        bottom: -50,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(150),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: -20,
                                        top: -50,
                                        child: Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(150),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text(
                                      'No event found. Click + to add.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .merge(TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            ): ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: eventList == null ? 0 : eventList.length,
            itemBuilder: (BuildContext context, int position) {
              Event ev = eventList[position];
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFdc3545),
                    child: GestureDetector(
                      child: Icon(Icons.edit, color: Colors.white,),
                      onTap: () {
                        print('Edit Event ${ev.id} is Clicked');
                        navigateToAddEvent(ev, 'Edit Event');
                      },
                    ),
                  ),
                  title: Text(ev.title, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
                  subtitle: Text('Created on '+ev.date, style: TextStyle(color: Colors.grey),),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete, color: Color(0xFFdc3545), size: 40,),
                    onTap: () async {
                      // await dbHelper.deleteEvent(ev.id);
                      // setState(() {
                      //   eventList.removeAt(position);
                      // });
                      _showALertDialog('Confirm Delete', 'Are you sure to delete event ${ev.title}?',
                          ev, position, context);
                      // _delete(context, ev, position);
                      print('Delete icon pressed id = ${ev.id}');
                    },
                  ),
                  onTap: () {
                    debugPrint('Event List Tapped');
                    navigateToDetail(ev, eventList);
                    // navigateToAddEvent(this.eventList[position], 'Update Event');
                    // navigateToEventDetail(this.eventList[position],'Event Details', this.eventList, Detail('', '', ''));
                  },
                ),
              );
            },
          );
        }else{
          Text('Hello', style: TextStyle(color: Colors.white));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void navigateToDetail(Event event, List<Event> eventList) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EventDetail(event, eventList);
      // return EvDetail(event, eventList);
    }));
  }

  void navigateToAddEvent(Event event, String title) async {
    // print(event.title);

    await Navigator.push(context, MaterialPageRoute(builder: (context) {
     
       return AddEvent(event, title);
    }));
    // Navigator.pushNamed(context, '/addEvent', arguments: {event: event});
    // Navigator.pushNamed(context, '/addEvent', arguments: {'event': event, 'title': title});
  }

  void _delete(BuildContext context, Event event, int position) async {
    // await dbHelper.deleteEventDetail(event.title);
    if (eventList.length == null) {
      int result = await dbHelper.deleteEvent(event.id);
      setState(() {
        eventList.removeAt(position);
      });
      if (result != 0) {
        _showSnackBar(context, 'Event Deleted Successfully!');
        // _showALertDialog('Status', 'Are you sure want to delete?', '');

      }
    }
    print(eventList);
  }

  //Showing saved dialog box
  void _showALertDialog(
      String title, String message, Event event, int position, BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () async {
            var result = await dbHelper.getDetailListBy(event.title);


            // print(result.length);
            if (result.length == 0) {
              await dbHelper.deleteEvent(event.id);
              setState(() {
                eventList.removeAt(position);
              });
            } else {
              _showSnackBar(context,
                  'Sorry, you cannot delete event until there is some data!');
            }
            Navigator.of(context).pop();
          },
        ),
      ],
      // backgroundColor: Colors.blue,
      // shape: CircleBorder(),
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
 _shareApp() async {
    try {
      String projectAppID, name;

      projectAppID = await GetVersion.appID;
      name = await GetVersion.appName;
      Share.share(name +
          " \nhttps://play.google.com/store/apps/details?id=" +
          projectAppID);
    } on Exception {}
  }

  //Showing saved dialog box
  void _showAbout(
      String title, String message, BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title,textAlign: TextAlign.center,),
      content: Text(message, textAlign: TextAlign.center,),
      actions: [
        Center(
          child: Row(
            children: <Widget>[
              
            ],
          ),
        ),
        Center(
          child: FlatButton(
            child: Text('Ok'),
            onPressed: ()  {
              Navigator.pop(context);
            }
          ),
        ),
        
        Center(
          child: FlatButton(
            child: Text('Rate'),
            onPressed: ()  {
                    launch(
                  "https://play.google.com/store/apps/details?id=thulo_event.com");
              Navigator.pop(context);
            }
          ),
        ),
         Center(
          child: FlatButton(
            child: Text('Share'),
            onPressed: ()  {
               Navigator.pop(context);
                    _shareApp();
            }
          ),
        ),
          Center(
            child: FlatButton(
            child: Text('Video'),
            onPressed: ()  {
             Navigator.pop(context);
                 launch("https://youtu.be/Y76NCk2YjQU");
            }
        ),
          ),
      ],
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateEventDetail() {
    final Future<List<Event>> dbFuture = dbHelper.getEventList();
    dbFuture.then((eventList) {
      setState(() {
        this.eventList = eventList;
      });
    });
  }

}
