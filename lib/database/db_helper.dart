import 'package:sqflite/sqflite.dart';
import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import '../models/event.dart';
import '../models/detail.dart';
import 'package:path/path.dart';

class DbHelper {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'thulo_event.db'),
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE event_table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT unique, date TEXT)",
          );

          await db.execute(
              "CREATE TABLE detail_table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, name TEXT, contact TEXT, remarks TEXT, FOREIGN KEY (title) REFERENCES event_table(title))");
        },
        version: 1,
      );
    }

    return _database;
  }

  Future<int> insertEvent(Event event) async {
    await openDb();
    return await _database.insert('event_table', event.toMap());
  }

  Future<int> updateEvent(Event event) async {
    await openDb();
    return await _database.update('event_table', event.toMap(),
        where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> insertDetails(Detail detail) async {
    await openDb();
    return await _database.insert('detail_table', detail.toMap());
  }

  Future<int> updateDetail(Detail detail) async {
    await openDb();
    return await _database.update('detail_table', detail.toMap(),
        where: 'id = ?', whereArgs: [detail.id]);
  }

  Future<int> updateEventDetail(String newTitle, String oldTitle) async {
    await openDb();
    return await _database.rawUpdate(
        'UPDATE detail_table SET title = "$newTitle" WHERE title = "$oldTitle"');
  }

  Future<List<Event>> getEventList() async {
    await openDb();

    final List<Map<String, dynamic>> maps =
        await _database.query('event_table');

    return List.generate(maps.length, (i) {
      return Event(
          id: maps[i]['id'], title: maps[i]['title'], date: maps[i]['date']);
    });
  }

  Future<List<Detail>> getDetailList() async {
    await openDb();

    // final List<Map<String, dynamic>> maps = await _database.query('detail_table', orderBy: 'name ASC');
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('Select * from detail_table order by name ASC');

    return List.generate(maps.length, (i) {
      return Detail(
          id: maps[i]['id'],
          title: maps[i]['title'],
          name: maps[i]['name'],
          contact: maps[i]['contact'],
          remarks: maps[i]['remarks']);
    });
  }

  Future<int> deleteEvent(int id) async {
    await openDb();

    return await _database.rawDelete('DELETE FROM event_table where id = $id');
  }

  Future<int> deleteEventDetail(String eventTitle) async {
    await openDb();

    return await _database
        .rawDelete('DELETE FROM detail_table where title = "$eventTitle"');
  }

  Future<int> deleteDetail(int id) async {
    await openDb();

    return await _database.rawDelete('DELETE FROM detail_table where id = $id');
  }

  // Get All the detail object from the detabase according to event
  Future<List<Map<String, dynamic>>> getEventDetailMapList(
      String dTitle) async {
    await openDb();

    var result = await _database
        .rawQuery('SELECT * FROM detail_table WHERE title = "$dTitle"');

    return result;
  }

  Future<List<Detail>> getDetailListBy(String dTitle) async {
    await openDb();

    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM detail_table WHERE title = "$dTitle"');

    return List.generate(maps.length, (i) {
      return Detail(
          id: maps[i]['id'],
          title: maps[i]['title'],
          name: maps[i]['name'],
          contact: maps[i]['contact'],
          remarks: maps[i]['remarks']);
    });
  }

  Future<List<Detail>> getDetailListById(int id) async {
    await openDb();

    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM detail_table WHERE id = $id');

    return List.generate(maps.length, (i) {
      return Detail(
          id: maps[i]['id'],
          title: maps[i]['title'],
          name: maps[i]['name'],
          contact: maps[i]['contact'],
          remarks: maps[i]['remarks']);
    });
  }
}
