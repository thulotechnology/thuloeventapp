import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:pdf/pdf.dart';
import 'package:thulo_event/pdf_viewer.dart';
import './database/db_helper.dart';
import './models/event.dart';
import './models/detail.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;



class EventDetail extends StatefulWidget {
  // final String appBarTitle;
  final Event event;
  // final Detail detail;
  final List<Event> eventList;
  // final List<Detail> detailList;

  // EventDetail(this.event, this.appBarTitle, this.eventList, this.detail);
  EventDetail(this.event, this.eventList);

  @override
  _EventDetailState createState() =>
      _EventDetailState(this.event, this.eventList);
}

class _EventDetailState extends State<EventDetail> {
  DbHelper dbHelper = DbHelper();
  Event event;
  Detail detail;
  List<Event> eventList;
  List<Detail> detailList;
  bool isEmpty;
  Map eventEachData = {};
  Map<String, dynamic> detailBackup = Map();
  // int _count = 0;
  var _formkey = GlobalKey<FormState>();

  List<String> eventNames = List();

  String _selectedValue;
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  double screenWidth;
  String buttonName = "Add Details";
  int detail_id;

  String generatedPdfFilePath;

  @override
  void initState() {
    updateEventDetailBy();
    for (int i = 0; i < eventList.length; i++) {
      eventNames.add(eventList[i].title);
    }
    _selectedValue = event.title;
    // isEmpty = eventList == null ? true : false;
    super.initState();
  }

  _EventDetailState(this.event, this.eventList);

  @override
  Widget build(BuildContext context) {
    updateEventDetailBy();
    screenWidth = MediaQuery.of(context).size.width;

    TextStyle textStyle = Theme.of(context).textTheme.title;
    // TextStyle textStyleHint = Theme.of(context).textTheme.subhead;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Event Details'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
            child: GestureDetector(
              onTap: () {
                // (context as Element).reassemble();
                // printPdf();
                print('Printed');
                printPdf(context);
              },
              child: Icon(
                Icons.picture_as_pdf,
                size: 35.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
            child: GestureDetector(
              onTap: () async {
                _showALertDialog(
                    'Status', 'Do you want to delete all?', _selectedValue);
                // await dbHelper.deleteEventDetail(_selectedValue);
                print('Deleted all');
              },
              child: Icon(
                Icons.delete,
                size: 35.0,
                color: Color(0xFFdc3545),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 15, right: 10),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasFocus) {
                currentFocus.unfocus();
              }
              // FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: <Widget>[
                // First Element
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Event:',   style: textStyle,),
                        )),
                        Expanded(
                          flex: 5,
                                                  child: ListTile(
                  title: DropdownButton(
                    items: eventNames.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: _selectedValue,
                    onChanged: (String valueSelectedByUser) {
                      setState(() {
                          _selectedValue = valueSelectedByUser;
                      });
                    },
                  ),
                ),
                        ),
                    ],
                  ),

                // Text("Title: ${data.title}, id: ${data.id}"),

                // Second Element
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    maxLength: 70,
                    textCapitalization: TextCapitalization.words,
                    controller: nameController,
                    style: TextStyle(fontSize: 16.0),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter the name';
                      }
                    },
                    onChanged: (value) {
                      debugPrint('Changed Title TextField');
                      // detail.name = nameController.text;
                      // event.title = titleController.text;
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(fontSize: 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: contactNoController,
                    style: TextStyle(fontSize: 16.0),
                    // validator: (String value) {
                    //   if(value.isEmpty) {
                    //     return 'Please Enter the contact';
                    //   }
                    // },
                    onChanged: (value) {
                      debugPrint('Changed Contact TextField');
                      // detail.contactNo = contactNoController.text;
                    },
                    decoration: InputDecoration(
                      labelText: 'Contact No',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(fontSize: 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    maxLength: 250,
                    controller: remarksController,
                    style: TextStyle(fontSize: 16.0),
                    // validator: (String value) {
                    //   if (value.isEmpty) {
                    //     return 'Please Enter the remarks';
                    //   }
                    // },
                    onChanged: (value) {
                      debugPrint('Changed Title TextField');
                      // detail.name = nameController.text;
                      // event.title = titleController.text;
                    },
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(fontSize: 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      // Sava Button
                      Expanded(
                        child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                                                  child: Container(
                              color: Theme.of(context).primaryColorDark,
                            child: FlatButton(
                              textColor: Colors.white,
                              child: Text(
                                buttonName,
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint('Add button pressed');
                                  if (_formkey.currentState.validate()) {
                                    _saveDetails(context);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                                                  child: Container(
                             color: Colors.green,
                            child: FlatButton(
                             
                              textColor: Colors.white,
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  nameController.text = "";
                                  contactNoController.text = "";
                                  remarksController.text = "";
                                  // nameController.clear();
                                  // contactNoController.clear();
                                   buttonName = "Add Details";
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                  child: Text(
                    'Record of $_selectedValue',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                // getDetailListView(context),
                // detailsDataTable(),
                getDetailListTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> getDetailListView(BuildContext context) {
    return FutureBuilder(
        future: dbHelper.getDetailListBy(_selectedValue),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            detailList = snapshot.data;
            return Expanded(
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: detailList == null ? 0 : detailList.length,
                  itemBuilder: (BuildContext context, int position) {
                    Detail dt = detailList[position];
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: GestureDetector(
                            child: Icon(Icons.edit),
                            onTap: () {
                              editDetail(dt);
                            },
                          ),
                        ),
                        title: Text(dt.name),
                        subtitle: Text('${dt.contact}\n${dt.remarks}'),
                        trailing: GestureDetector(
                          child: Icon(Icons.delete, color: Colors.brown),
                          onTap: () {
                            deleteDetail(context, dt.id);
                            _showSnackBar(
                                context, 'Deleted Successfully!!', dt.id);
                          },
                        ),
                        onTap: () {
                          debugPrint('Event List Tapped');
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void updateEventDetailBy() {
    // get the Instance of the database
    final Future<List<Detail>> dbFuture =
        dbHelper.getDetailListBy(_selectedValue);
    dbFuture.then((detailList) {
      setState(() {
        this.detailList = detailList;
      });
    });
  }

  // Save details to the database
  _saveDetails(BuildContext context) async {
    var _eventDetail = Detail(
      id: detail_id,
      title: _selectedValue,
      name: nameController.text,
      contact: contactNoController.text,
      remarks: remarksController.text,
    );

    int result;
    String message;
    // result = await databaseHelper.insertDetail(_eventDetail);

    if (buttonName == "Add Details") {
      message = "Record Added Successfully!";
      result = await dbHelper.insertDetails(_eventDetail);
    } else {
      message = "Record Updated Successfully!";
      result = await dbHelper.updateDetail(_eventDetail);
      buttonName = "Add Details";
      detail_id = null;
    }
    if (result != 0) {
      // success
      //  _showSuccessMessage(context, 'Data Added Successfully');
      setState(() {
        nameController.clear();
        contactNoController.clear();
        remarksController.clear();
      });
         FlutterFlexibleToast.showToast(
      message: message,
      toastLength: Toast.LENGTH_LONG,
      timeInSeconds: 5
    );
    //  _showALertDialog('Status', message, '');
    } else {
      // Failed
      _showALertDialog('Status', 'Error!!!', '');
      // _showSuccessMessage(context, 'Error! while adding data');
    }

    FocusScope.of(context).unfocus();
  }

  void _showSuccessMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Showing saved dialog box
  void _showALertDialog(String title, String message, String titleValue) {
    bool isTitle = titleValue == '' ? true : false;
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text('Exit'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        isTitle
            ? null
            : FlatButton(
                child: Text('Delete all'),
                onPressed: () async {
                  await dbHelper.deleteEventDetail(titleValue);
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

  FutureBuilder<dynamic> getDetailListTable() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return FutureBuilder(
      future: dbHelper.getDetailListBy(_selectedValue),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          detailList = snapshot.data;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                // sortColumnIndex: 1,
                sortAscending: true,
                columns: [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.cyan,
                      ),
                    ),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text(
                      'Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Remarks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.cyan,
                      ),
                    ),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.cyan,
                      ),
                    ),
                    numeric: false,
                  ),
                ],
                rows: detailList
                    .map(
                      (detail) => DataRow(cells: [
                        // DataCell(Text(detail.title)),
                        DataCell(Text(detail.name)),
                        DataCell(Text(detail.contact)),
                        DataCell(Text(detail.remarks)),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.red),
                            onPressed: () {
                              editDetail(detail);
                            },
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteDetail(context, detail.id);
                               FlutterFlexibleToast.showToast(
      message: "Record Deleted Successfully!",
      toastLength: Toast.LENGTH_LONG,
    );
                            },
                          ),
                        ),
                      ]),
                    )
                    .toList(),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void editDetail(Detail detail) async {
    setState(() {
      buttonName = "Edit Details";
      nameController.text = detail.name;
      contactNoController.text = detail.contact;
      remarksController.text = detail.remarks;
      detail_id = detail.id;
    });
  }

  void deleteDetail(BuildContext context, int id) async {
    var eachDetail = await dbHelper.getDetailListById(id);
    detailBackup["dName"] = eachDetail[0].name;
    detailBackup["dTitle"] = eachDetail[0].title;
    detailBackup["dContact"] = eachDetail[0].contact;
    detailBackup["dRemarks"] = eachDetail[0].remarks;
    detailBackup["dId"] = eachDetail[0].id;
    // print(detailBackup);
    await dbHelper.deleteDetail(id);
  }

  void _showSnackBar(BuildContext context, String message, int id) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          var _eachDetail = Detail(
            title: detailBackup["dTitle"],
            name: detailBackup["dName"],
            contact: detailBackup["dContact"],
            remarks: detailBackup["dRemarks"],
          );

          // detail.id = detailBackup["dId"];

          await dbHelper.insertDetails(_eachDetail);

          print(_eachDetail);
          // await dbHelper.deleteDetail(id);
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> printPdf(BuildContext context) async {
    try {
       List<Detail> detList = await dbHelper.getDetailListBy(_selectedValue);
    final pw.Document pdf = pw.Document(deflate: zlib.encode);
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
                pw.Container(
                  alignment: pw.Alignment.topCenter,
                  // margin:
                  //     const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(
                      bottom: 3.0 * PdfPageFormat.mm, top: 3.0),
                  decoration: const pw.BoxDecoration(
                      border: pw.BoxBorder(
                    bottom: true,
                    top: true,
                    left: true,
                    right: true,
                    width: 1.0,
                    // color: PdfColors.gre,
                  )),
                  child: pw.Text(
                    'Event Name: '+_selectedValue,
                    style: pw.TextStyle(
                      fontSize: 20.0,
                      // color: PdfColors.red,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Container(
                  alignment: pw.Alignment.topRight,
                  // margin:
                  //     const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(
                      bottom: 3.0 * PdfPageFormat.mm, right: 3.0, top: 3.0),
                  decoration: const pw.BoxDecoration(
                      border: pw.BoxBorder(
                    bottom: true,
                    top: true,
                    left: true,
                    right: true,
                    width: 1.0,
                    // color: PdfColors.gre,
                  )),
                  child: pw.Text(
                    event.date,
                    style: pw.TextStyle(
                      fontSize: 10.0,
                      // color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                
                pw.Table.fromTextArray(context: context, data: <List<String>>[
                  <String>['SN','Full Name', 'Phone No', 'Remarks'],
                  ...detList.asMap().entries.map(
                      (item) {
                        return <String>[(item.key+1).toString(),item.value.name, item.value.contact, item.value.remarks];
                      } )
                  // (item) => [item.name.toString(), item.contact.toString()])
                ]),
                pw.Container(
                  alignment: pw.Alignment.topCenter,
                  // margin: const pw.EdgeInsets.only(top: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(
                      top: 3.0 * PdfPageFormat.mm, bottom: 3.0),
                  decoration: const pw.BoxDecoration(
                    border: pw.BoxBorder(
                    bottom: true,
                    top: true,
                    left: true,
                    right: true,
                    width: 1.0,
                    // color: PdfColors.gre,
                  )),
                  child: pw.Text(
                    "Generated By: Thulo Event App by Thulo Technology Pvt.Ltd.",
                    style: pw.TextStyle(
                      fontSize: 8.0,
                      fontBold: pw.Font.courier(),
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ]),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/event_details.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path, pdf: pdf),
    ));
    } catch (e) {
       FlutterFlexibleToast.showToast(
        message: "No data found. Please add data first.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        icon: ICON.ERROR,
        fontSize: 16,
        imageSize: 35,
        textColor: Colors.white);
    }
   
  }
}
