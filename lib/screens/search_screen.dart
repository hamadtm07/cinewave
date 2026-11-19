import 'package:flutter/material.dart';
import 'package:cinewave/models/movie_model.dart';
import 'package:cinewave/services/tmdb_service.dart';
import 'package:cinewave/themes/app_themes.dart';
import 'package:cinewave/widgets/widgets.dart';
import 'package:cinewave/screens/screens.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSuggestions();
  }

  void _loadInitialSuggestions() async {
    setState(() => _isLoading = true);
    final popular = await TmdbService.getPopular();
    if (mounted) {
      setState(() {
        _results = popular;
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      _loadInitialSuggestions();
      setState(() => _hasSearched = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final searchResults = await TmdbService.searchMovies(cleanQuery);
    if (mounted) {
      setState(() {
        _results = searchResults;
        _isLoading = false;
      });
    }
  }

  void _showRandomRecommendation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppThemes.primary),
      ),
    );

    final randomMovie = await TmdbService.getRandomMovie();

    if (mounted) {
      Navigator.pop(context);
      _displayRecommendationDialog(randomMovie);
    }
  }

  void _displayRecommendationDialog(MovieModel movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppThemes.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.casino_rounded, color: AppThemes.primary, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Recomendación Aleatoria',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppThemes.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Color(0x1AD4AF37), height: 16),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 85,
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppThemes.primary, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/jar-loading.gif'),
                        image: NetworkImage(movie.posterPath),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) => Container(
                          color: AppThemes.darkBackground,
                          child: const Icon(Icons.movie, color: AppThemes.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppThemes.systemMatch.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppThemes.systemMatch),
                          ),
                          child: Text(
                            '${movie.matchPercentage}% coincidencia',
                            style: const TextStyle(
                              color: AppThemes.systemMatch,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate,
                              style: const TextStyle(color: AppThemes.textSecondary, fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star_rounded, color: AppThemes.primary, size: 15),
                            const SizedBox(width: 2),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(color: AppThemes.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          movie.overview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppThemes.textSecondary, fontSize: 11, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppThemes.primary.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showRandomRecommendation();
                      },
                      icon: const Icon(Icons.refresh_rounded, color: AppThemes.primary, size: 18),
                      label: const Text('Otra película', style: TextStyle(color: AppThemes.primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppThemes.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(movie: movie),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Ver Detalles', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkBackground,
      appBar: AppBar(
        backgroundColor: AppThemes.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppThemes.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: AppThemes.textPrimary, fontSize: 16),
          cursorColor: AppThemes.primary,
          textInputAction: TextInputAction.search,
          onSubmitted: _performSearch,
          decoration: InputDecoration(
            hintText: 'Buscar en The Movie DB...',
            hintStyle: const TextStyle(color: AppThemes.textSecondary, fontSize: 14),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppThemes.primary, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search, color: AppThemes.primary, size: 22),
                    onPressed: () => _performSearch(_searchController.text),
                  ),
          ),
          onChanged: (text) {
            setState(() {});
            if (text.length > 2) {
              _performSearch(text);
            }
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppThemes.primary.withValues(alpha: 0.6), width: 1.2),
                backgroundColor: AppThemes.primary.withValues(alpha: 0.12),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.casino_rounded, color: AppThemes.primary, size: 20),
              label: const Text(
                '¿No sabes qué ver? Recomiéndame una película',
                style: TextStyle(
                  color: AppThemes.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              onPressed: _showRandomRecommendation,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _hasSearched ? 'Resultados para "${_searchController.text}"' : 'Recomendadas para ti',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppThemes.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppThemes.primary.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'TMDB API',
                    style: TextStyle(
                      color: AppThemes.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppThemes.primary,
                    ),
                  )
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_filter_outlined,
                              size: 64,
                              color: AppThemes.primary.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No se encontraron películas',
                              style: TextStyle(
                                color: AppThemes.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Intenta buscar con otro título o palabra clave',
                              style: TextStyle(
                                color: AppThemes.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final movie = _results[index];
                          return MoviePosterCard(
                            movie: movie,
                            width: double.infinity,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(movie: movie),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
