class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final String genre;
  final List<int> genreIds;
  final int matchPercentage;

  static const Map<int, String> genreMap = {
    28: 'Acción',
    12: 'Aventura',
    16: 'Animación',
    35: 'Comedia',
    80: 'Crimen',
    99: 'Documental',
    18: 'Drama',
    10751: 'Familia',
    14: 'Fantasía',
    36: 'Historia',
    27: 'Terror',
    10402: 'Música',
    9648: 'Misterio',
    10749: 'Romance',
    878: 'Ciencia Ficción',
    53: 'Suspenso',
    10752: 'Bélica',
    37: 'Western',
  };

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genre,
    this.genreIds = const [],
    this.matchPercentage = 95,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final vote = (json['vote_average'] as num?)?.toDouble() ?? 7.5;
    final match = (vote * 10).round().clamp(75, 99);
    final rawDate = json['release_date']?.toString() ?? '';
    final year = rawDate.isNotEmpty ? rawDate.split('-')[0] : '2024';

    final poster = json['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
        : 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500';

    final backdrop = json['backdrop_path'] != null
        ? 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}'
        : poster;

    final rawOverview = json['overview']?.toString().trim() ?? '';
    final summary = rawOverview.isNotEmpty
        ? rawOverview
        : 'Explora esta historia en los cines y plataformas digitales a través de la base de datos de The Movie DB.';

    final rawGenreIds = (json['genre_ids'] as List?)?.map((e) => e as int).toList() ?? [];
    String genreName = 'Película';
    if (rawGenreIds.isNotEmpty && genreMap.containsKey(rawGenreIds.first)) {
      genreName = genreMap[rawGenreIds.first]!;
    }

    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      overview: summary,
      posterPath: poster,
      backdropPath: backdrop,
      voteAverage: vote,
      releaseDate: year,
      genre: genreName,
      genreIds: rawGenreIds,
      matchPercentage: match,
    );
  }
}
