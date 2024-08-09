// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:tuneflow/models/songs.dart';
// import 'package:uuid/uuid.dart';

// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';

// List<String> audioUrl = [];
// List<String> songNames = [];
// List<String> artistList = [];
// List<String> titleList = [];

// List<Songs> allAvailableSongsFstg = [];

// const uid = Uuid();

// void loadPlaces() async {
//   final db = await getDatabase();
//   final data = await db.query('available_songs');
//   data.map((row) => );
// }

// Future<Database> getDatabase() async {
//   final dbPath =
//       await sql.getDatabasesPath(); //return the path of database on machine
//   //onCreate will gets executed when the database songs is created
//   final db = await sql.openDatabase(
//     path.join(dbPath, 'songs.db'),
//     onCreate: (db, version) {
//       return db.execute(
//           'create table available_songs(id TEXT PRIMARY KEY, name TEXT, artist TEXT, location TEXT, duration TEXT)'); //executing a sql query
//     },
//     version: 1,
//   );
//   return db;
// }

// Future<void> loadData() async {
//   await availableSongsUrl(); // Fetch audio URLs
//   await songNamesFromFirebaseStorage(); // Fetch audio names

//   //extracting songName and artist name
//   for (String track in songNames) {
//     List<String> parts = track.split(' - ');
//     if (parts.length == 2) {
//       String title = parts[0].trim();
//       String songName = parts[1].replaceAll(RegExp(r'\.mp3$'), '').trim();

//       artistList.add(title);
//       titleList.add(songName);
//     }
//   }

//   // // To save the data locally on the machine which the app is running
//   // final dbPath =
//   //     await sql.getDatabasesPath(); //return the path of database on machine
//   // //onCreate will gets executed when the database songs is created
//   // final db = await sql.openDatabase(
//   //   path.join(dbPath, 'songs.db'),
//   //   onCreate: (db, version) {
//   //     return db.execute(
//   //         'create table available_songs(id TEXT PRIMARY KEY, name TEXT, artist TEXT, location TEXT, duration TEXT)'); //executing a sql query
//   //   },
//   //   version: 1,
//   // );
//   final db = await getDatabase();
//   //loading the data (songs) into model names Songs
//   for (int i = 0; i < audioUrl.length; i++) {
//     // allAvailableSongsFstg.add(Songs(
//     //   id: uid.v4(),
//     //   name: songNames[i],
//     //   artist: artistList[i],
//     //   location: audioUrl[i],
//     // ));

//     db.insert('available_songs', {
//       'id': uid.v4(),
//       'name': songNames[i],
//       'artist': artistList[i],
//       'location': audioUrl[i],
//       'duration':
//           '00:00' // Duration will be fetched later using the audio file library.
//     });
//   }
// }

// Future<void> availableSongsUrl() async {
//   final songStorage = FirebaseStorage.instance;
//   ListResult result = await songStorage.ref().child('availableSongs').listAll();

//   for (Reference ref in result.items) {
//     String url = await ref.getDownloadURL();
//     audioUrl.add(url);
//   }
// }

// Future<void> songNamesFromFirebaseStorage() async {
//   final storage = FirebaseStorage.instance;
//   ListResult result = await storage.ref('availableSongs').listAll();

//   for (Reference ref in result.items) {
//     songNames.add(ref.name);
//   }
// }
