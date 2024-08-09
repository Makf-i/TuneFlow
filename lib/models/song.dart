class Song {
  final String id;
  final String name;
  final String artist;
  final String location;
  final String duration;
  final String genre;
  final bool isFavorite;
  final bool isRunning;

  Song({
    required this.id,
    required this.name,
    required this.artist,
    this.duration = "00:00",
    required this.location,
    this.genre = '',
    this.isFavorite = false,
    this.isRunning = false,
  });

  Song copyWith({
    String? id,
    String? name,
    String? artist,
    String? location,
    bool? isRunning,
  }) {
    return Song(
      isRunning: isRunning ?? this.isRunning,
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      location: location ?? this.location,
      genre: this.genre,
      isFavorite: this.isFavorite,
    );
  }
}
