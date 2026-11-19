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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  child: Text(
                    'TMDB API',
                    style: const TextStyle(
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
