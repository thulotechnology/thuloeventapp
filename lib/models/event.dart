class Event {
  int id;
  String title;
  String date;

  Event({this.id, this.title, this.date});

  // Convert the Event Object into a map object
  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date};
    // var map = Map<String, dynamic>();

    // if(id != null) {
    //   map['id'] = id;
    // }

    // map['title'] = title;
    // map['date'] = date;

    // return map;
  }

  // Extract a Event Object from a Map Object
  // Creating a named constructor
  // Event.fromMapObject(Map<String, dynamic> map) {
  //   this.id = map['id'];
  //   this.title = map['title'];
  //   this.date = map['date'];
  // }
}
