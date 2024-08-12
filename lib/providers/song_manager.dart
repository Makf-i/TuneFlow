import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TuneFlow/models/song.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'songs.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE avlbSongs ('
        'id TEXT PRIMARY KEY, '
        'name TEXT, '
        'artist TEXT, '
        'location TEXT, '
        'duration TEXT, '
        'genre TEXT, '
        'isFavorite BOOLEAN, '
        'isPlaying BOOLEAN'
        ')',
      );
    },
    version: 1,
  );
}

class SongManagerNotifier extends StateNotifier<List<Song>> {
  SongManagerNotifier(this.ref) : super([]) {
    _lastPlayedSong = null;
  }

  final Ref ref;
  Song? _lastPlayedSong;

  Song? get lastPlayedSong => _lastPlayedSong;

  Future<void> loadSongs(List<Song> songs) async {
    final db = await getDatabase();

    for (Song sng in songs) {
      final List<Map<String, dynamic>> result = await db.query(
        'avlbSongs',
        where: 'id = ?',
        whereArgs: [sng.id],
      );
      if (result.isEmpty) {
        await db.insert('avlbSongs', {
          'id': sng.id,
          'name': sng.name,
          'artist': sng.artist,
          'location': sng.location,
          'duration': sng.duration,
          'genre': sng.genre,
          'isFavorite': sng.isFavorite ? 1 : 0,
          'isPlaying': sng.isPlaying ? 1 : 0,
        });
      }
    }
    state = songs;
  }

  Future<void> updateSongRunningStatus(String songId, bool isPlaying) async {
    final db = await getDatabase();
    final songExist = await db.query(
      'avlbSongs',
      where: 'id = ?',
      whereArgs: [songId],
    );
    if (songExist.isNotEmpty) {
      await db.update(
        'avlbSongs',
        {'isPlaying': isPlaying ? 1 : 0},
        where: 'id = ?',
        whereArgs: [songId],
      );
      state = [
        for (Song song in state)
          if (song.id == songId) song.copyWith(isPlaying: isPlaying) else song
      ];
      _lastPlayedSong = state.firstWhere(
        (song) => song.id == songId,
        orElse: () =>
            _lastPlayedSong ??
            Song(
              id: '',
              location: '',
              name: '',
              artist: '',
              isFavorite: false,
              isPlaying: false,
            ),
      );
    } else {
      print('Song with ID $songId does not exist in the database.');
    }
  }

  bool toggleFavoriteStatus(Song sng) {
    final newStatus = !sng.isFavorite;
    state = [
      for (Song s in state)
        if (s.id == sng.id) s.copyWith(isFavorite: newStatus) else s
    ];
    _updateFavoriteStatusInDb(sng.id, newStatus);
    return newStatus;
  }

  Future<void> _updateFavoriteStatusInDb(String songId, bool isFavorite) async {
    final db = await getDatabase();
    final songExist = await db.query(
      'avlbSongs',
      where: 'id = ?',
      whereArgs: [songId],
    );
    if (songExist.isNotEmpty) {
      await db.update(
        'avlbSongs',
        {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [songId],
      );
    } else {
      print('Song with ID $songId does not exist in the database.');
    }
  }

  bool toggleRunningStatus(Song song) {
    final newStatus = !song.isPlaying;
    state = [
      for (Song s in state)
        if (s.id == song.id) s.copyWith(isPlaying: newStatus) else s
    ];
    updateSongRunningStatus(song.id, newStatus);
    return newStatus;
  }

  void addSong(Song song) {
    state = [...state, song];
  }

  Future<Song> currentSongFromDb(Song song) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      'avlbSongs',
      where: 'id = ?',
      whereArgs: [song.id],
    );
    if (result.isNotEmpty) {
      return Song(
        id: result[0]['id'],
        name: result[0]['name'],
        artist: result[0]['artist'],
        location: result[0]['location'],
        duration: result[0]['duration'],
        genre: result[0]['genre'],
        isFavorite: result[0]['isFavorite'] == 1,
        isPlaying: result[0]['isPlaying'] == 1,
      );
    } else {
      return Song(
        id: 'id',
        name: 'name',
        artist: 'artist',
        location: 'location',
        duration: 'duration',
        genre: 'genre',
        isFavorite: false,
        isPlaying: false,
      );
    }
  }
}

final songProvider =
    StateNotifierProvider<SongManagerNotifier, List<Song>>((ref) {
  return SongManagerNotifier(ref);
});

final songFromDbProvider = FutureProvider.family<Song, Song>((ref, song) async {
  final songManager = ref.watch(songProvider.notifier);
  return await songManager.currentSongFromDb(song);
});
