class Detail {
  int id;
  String title;
  String name;
  String contact;
  String remarks;

  Detail({this.id, this.title, this.name, this.contact, this.remarks});

  // Convert the Event Details Object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['name'] = name;
    map['contact'] = contact;
    map['remarks'] = remarks;

    return map;
  }

  // Extract a Event Detail Object from a Map Object
  // Creating a named constructor
  Detail.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.name = map['name'];
    this.contact = map['contact'];
    this.remarks = map['remarks'];
  }
}
