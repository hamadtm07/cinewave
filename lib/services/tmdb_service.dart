import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinewave/models/movie_model.dart';

class TmdbService {
  static const String _apiKey = '15d2ea6d0dc1d476efbca3eba2b9bbfb';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _language = 'es-ES';

  static final List<MovieModel> fallbackMovies = [
    const MovieModel(
      id: 693134,
      title: 'Dune: Parte Dos',
      overview: 'Sigue el viaje mítico de Paul Atreides mientras se une a Chani y los Fremen en una guerra de venganza contra los conspiradores que destruyeron a su familia.',
      posterPath: 'https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8PY05Nxl1X.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w780/xOMo8BRK7PfcJv9JCnx7s5hj0x2.jpg',
      voteAverage: 8.2,
      releaseDate: '2024',
      genre: 'Ciencia Ficción',
      genreIds: [878, 12],
      matchPercentage: 98,
    ),
    const MovieModel(
      id: 157336,
      title: 'Interstellar',
      overview: 'Un equipo de exploradores viaja a través de un agujero de gusano en el espacio en un intento por garantizar la supervivencia de la humanidad.',
      posterPath: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w780/xJHokMbljvjADYdit5fK5VQsXEG.jpg',
      voteAverage: 8.4,
      releaseDate: '2014',
      genre: 'Ciencia Ficción',
      genreIds: [878, 18],
      matchPercentage: 96,
    ),
    const MovieModel(
      id: 872585,
      title: 'Oppenheimer',
      overview: 'La historia del científico J. Robert Oppenheimer y su rol decisivo en el desarrollo de la bomba atómica durante el Proyecto Manhattan.',
      posterPath: 'https://image.tmdb.org/t/p/w500/ncKCQVXgk4BcQV6XbvesgZ2zLvZ.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w780/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg',
      voteAverage: 8.1,
      releaseDate: '2023',
      genre: 'Drama',
      genreIds: [18, 36],
      matchPercentage: 94,
    ),
    const MovieModel(
      id: 558449,
      title: 'Gladiador II',
      overview: 'Años después de presenciar la muerte del venerado héroe Máximo a manos de su tío, Lucio debe ingresar al Coliseo tras ser conquistado su hogar.',
      posterPath: 'https://image.tmdb.org/t/p/w500/2cxhvwyEwRlysAmRH4iodkvo0z5.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w780/euYIWhGvdaRhuPJA2NBDEuds2xm.jpg',
      voteAverage: 7.8,
      releaseDate: '2024',
      genre: 'Acción',
      genreIds: [28, 12],
      matchPercentage: 91,
    ),
    const MovieModel(
      id: 27205,
      title: 'Origen (Inception)',
      overview: 'Dom Cobb es un ladrón capaz de adentrarse en los sueños de la gente para robar secretos de sus subconscientes.',
      posterPath: 'https://image.tmdb.org/t/p/w500/tXQvtRWfkUUnWJAnXZNjpEjm2EM.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w780/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg',
      voteAverage: 8.4,
      releaseDate: '2010',
      genre: 'Acción',
      genreIds: [28, 878],
      matchPercentage: 97,
    ),
    const MovieModel(
      id: 414906,
      title: 'The Batman',
      overview: 'En su segundo año luchando contra el crimen, Batman explora la corrupción existente en Gotham City y el vínculo de esta con su propia familia.',
      posterPath: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      backdropPath: 'https://image.tmdb.org/t/p/w780/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg',
      voteAverage: 7.7,
      releaseDate: '2022',
      genre: 'Crimen',
      genreIds: [80, 9648],
      matchPercentage: 93,
    ),
  ];

  static Future<List<MovieModel>> getNowPlaying() async {
    final url = Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$_language&page=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['results'] ?? [];
        if (list.isNotEmpty) {
          return list.map((item) => MovieModel.fromJson(item)).toList();
        }
      }
    } catch (_) {}
    return fallbackMovies;
  }

  static Future<List<MovieModel>> getPopular() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=$_language&page=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['results'] ?? [];
        if (list.isNotEmpty) {
          return list.map((item) => MovieModel.fromJson(item)).toList();
        }
      }
    } catch (_) {}
    return fallbackMovies;
  }

  static Future<List<MovieModel>> getTopRated() async {
    final url = Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=$_language&page=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['results'] ?? [];
        if (list.isNotEmpty) {
          return list.map((item) => MovieModel.fromJson(item)).toList();
        }
      }
    } catch (_) {}
    return fallbackMovies;
  }

  static Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    if (genreId == 0) {
      return getPopular();
    }
    final url = Uri.parse('$_baseUrl/discover/movie?api_key=$_apiKey&language=$_language&sort_by=popularity.desc&with_genres=$genreId&page=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['results'] ?? [];
        if (list.isNotEmpty) {
          return list.map((item) => MovieModel.fromJson(item)).toList();
        }
      }
    } catch (_) {}
    return fallbackMovies.where((m) => m.genreIds.contains(genreId)).toList();
  }

  static Future<List<MovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    final encoded = Uri.encodeComponent(query.trim());
    final url = Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&language=$_language&query=$encoded');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['results'] ?? [];
        return list.map((item) => MovieModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return fallbackMovies.where((m) => m.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Future<MovieModel> getRandomMovie() async {
    final popular = await getPopular();
    final topRated = await getTopRated();
    final pool = [...popular, ...topRated];
    if (pool.isNotEmpty) {
      pool.shuffle();
      return pool.first;
    }
    return fallbackMovies.first;
  }
}
