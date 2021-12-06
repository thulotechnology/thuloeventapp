import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thulo_event/database/db_helper.dart';
import './models/event.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';


class AddEvent extends StatefulWidget {
  final String appBarTitle;
  final Event event;
  

  AddEvent(this.event, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _AddEventState(this.event, this.appBarTitle);
  }
}

class _AddEventState extends State<AddEvent> {
  DbHelper dbHelper = DbHelper();
  String appBarTitle;
  Event event;
  var oldTitle;

  var _formkey = GlobalKey<FormState>();

  _AddEventState(this.event, this.appBarTitle);

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = event.title;
    oldTitle = event.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 15, right: 10),
          child: ListView(
            children: <Widget>[
              // First Element
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextFormField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: titleController,
                  style: textStyle,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter the name';
                    }
                  },
                  onChanged: (value) {
                    debugPrint('Changed Title TextField');
                    event.title = titleController.text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Event Title. E.g. Birthday Program',
                    labelStyle: textStyle,
                    errorStyle: TextStyle(fontSize: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),

              // Third Element
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                child: Row(
                  children: <Widget>[
                    // Sava Button
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                                              child: Container(
                          color: Colors.black,
                          child: FlatButton(
                             
                              child: Text(
                                'Save',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint('Save button pressed');
                                  if (_formkey.currentState.validate()) {
                                   return _save();
                                  }
                                });
                              },
                            ),
                        ),
                      ),
                    ),

                    // Container
                    Container(
                      width: 5.0,
                    ),

                    // Delete Button
                    Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                color: Colors.red,
                          child: FlatButton(
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Delete button pressed');
                                _delete();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   _save() async {
     try {
        int result;
    event.date = DateFormat.yMMMd().format(DateTime.now());
    var newTitle = titleController.text;
    if (event.id != null) {
      await dbHelper.updateEventDetail(newTitle, oldTitle);
      result = await dbHelper.updateEvent(event);
    } else {

      result = await dbHelper.insertEvent(event);
    }
    Navigator.pop(context);

    if (result != 0) {
      titleController.clear();
       FlutterFlexibleToast.showToast(
      message: "Event Saved Successfully!",
      toastLength: Toast.LENGTH_LONG,
    );
      return true;
    } else {
      return false;
    }
     } catch (e) {
       FlutterFlexibleToast.showToast(
        message: "This record already exists. Try different name.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        icon: ICON.ERROR,
        fontSize: 16,
        imageSize: 35,
        textColor: Colors.white);
     }
   
  }

  // Delete event
  void _delete() async {}
}
